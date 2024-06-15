import math
from flask import Flask, flash, make_response, redirect, render_template, request, send_from_directory, url_for
from sqlalchemy import MetaData, desc, func
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import login_required, current_user, LoginManager, login_user, logout_user
import bleach
import markdown
from datetime import date, datetime, timedelta
import os

app = Flask(__name__)
application = app

app.config.from_pyfile('config.py')

convention = {
    "ix": 'ix_%(column_0_label)s',
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s"
}

metadata = MetaData(naming_convention=convention)
db = SQLAlchemy(app, metadata=metadata)
migrate = Migrate(app, db)

PERMITTED_PARAMS = ["name", "short_desc", "year", "pub_house", "author", "volume"]
from auth import auth_bp, init_login_manager, check_rights
from comments import comments_bp
from tools import ImageSaver
from models import Image, Book, Genre, Comment

app.register_blueprint(auth_bp)
app.register_blueprint(comments_bp)

init_login_manager(app)

def get_viewed_books():
    viewed_books = []
    if request.cookies.get('viewed_books'):
        books = request.cookies.get('viewed_books').split(',')
        for book in books:
            viewed_book = db.session.query(Book).filter(Book.id == int(book)).scalar()
            if viewed_book:
                viewed_books.append(viewed_book)
    return viewed_books

@app.route('/')
def index():
    page = request.args.get('page', 1, type=int)
    per_page = app.config['PER_PAGE']
    viewed_books = get_viewed_books()
    info_about_books = []
    books_query = db.session.query(Book)

    # Получение параметров поиска
    title = request.args.get('title')
    genre_ids = request.args.getlist('genre')
    years = request.args.getlist('year')
    author = request.args.get('author')
    volume_from = request.args.get('volume_from')
    volume_to = request.args.get('volume_to')

    if title:
        books_query = books_query.filter(Book.name.ilike(f'%{title}%'))
    if genre_ids:
        books_query = books_query.join(Book.genres).filter(Genre.id.in_(genre_ids))
    if years:
        books_query = books_query.filter(Book.year.in_(years))
    if author:
        books_query = books_query.filter(Book.author.ilike(f'%{author}%'))
    if volume_from:
        books_query = books_query.filter(Book.volume >= int(volume_from))
    if volume_to:
        books_query = books_query.filter(Book.volume <= int(volume_to))

    books_counter = books_query.count()
    books = books_query.order_by(desc(Book.year)).limit(per_page).offset(per_page * (page - 1)).all()
    
    for book in books:
        info = {
            'book': book,
            'genres': book.genres,
        }
        info_about_books.append(info)

    page_count = math.ceil(books_counter / per_page)
    
    # Получение всех жанров и годов для формы поиска
    genres = db.session.query(Genre).all()
    years = db.session.query(Book.year).distinct().all()

    return render_template(
        'index.html',
        books=info_about_books,
        page=page,
        page_count=page_count,
        viewed_books=viewed_books,
        genres=genres,
        years=[year[0] for year in years],  # Преобразуем список кортежей в список значений
        search_params=request.args  # Передаем текущие параметры поиска для сохранения состояния формы
    )

@app.route('/images/<image_id>')
def image(image_id):
    img = db.get_or_404(Image, image_id)
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               img.storage_filename)

def params(names_list):
    result = {}
    for name in names_list:
        result[name] = request.form.get(name) or None
    return result

@app.route('/books/new')
@login_required
@check_rights("create")
def new_book():
    genres = db.session.query(Genre).all()
    return render_template('books/new.html', genres=genres, book={}, new_genres=[])

@app.route('/books/new', methods=['GET', 'POST'])
@login_required
@check_rights("create")
def new_book_route():
    genres = db.session.query(Genre).all()
    if request.method == 'POST':
        if not current_user.can("create"):
            flash("Недостаточно прав для доступа к странице", "warning")
            return redirect(url_for("index"))
        cur_params = params(PERMITTED_PARAMS)
        for param in cur_params:
            cur_params[param] = bleach.clean(cur_params[param])
        new_genres = request.form.getlist('genre_id')
        try:
            f = request.files.get('cover_img')
            if f and f.filename:
                img = ImageSaver(f)
                db_img = img.save_to_db()
            else:
                db_img = None
            book = Book(**cur_params, image_id=db_img.id if db_img else None)
            for genre in new_genres:
                new_genre = db.session.query(Genre).filter_by(id=genre).scalar()
                book.genres.append(new_genre)
            db.session.add(book)
            db.session.commit()
            if db_img:
                img.save_to_system()
            flash(f"Книга '{book.name}' успешно добавлена", "success")
            return redirect(url_for('show', book_id=book.id))
        except Exception as e:
            db.session.rollback()
            flash(f"При сохранении возникла ошибка: {str(e)}", "danger")
            return render_template("books/new.html", genres=genres, book=cur_params, new_genres=new_genres)
    return render_template('books/new.html', genres=genres, book={}, new_genres=[])

@app.route('/delete_post/<int:book_id>', methods=['POST'])
@login_required
@check_rights('delete')
def delete_post(book_id):
    try:
        book = db.session.query(Book).filter(Book.id == book_id).scalar()
        if book:
            # Удаляем связанные жанры
            book.genres = []
            db.session.commit()
            
            # Удаляем связанные комментарии
            db.session.query(Comment).filter(Comment.book_id == book_id).delete()
            
            # Проверяем, используется ли изображение в других книгах
            count_of_images = db.session.query(Book).filter(Book.image_id == book.image_id).count()
            
            # Удаляем саму книгу
            db.session.delete(book)
            db.session.commit()
            
            # Удаляем изображение, если оно не используется в других книгах
            if count_of_images == 1:
                image = db.session.query(Image).filter(Image.id == book.image_id).scalar()
                if image:
                    db.session.delete(image)
                    db.session.commit()
                    os.remove(os.path.join(app.config['UPLOAD_FOLDER'], image.storage_filename))

            # Обновляем куки с просмотренными книгами
            res = make_response(redirect(url_for('index')))
            if request.cookies.get('viewed_books'):
                viewed_books = []
                book_ids = request.cookies.get('viewed_books').split(',')
                for id in book_ids:
                    if id != str(book_id):
                        viewed_books.append(id)
                res.set_cookie('viewed_books', ','.join(viewed_books), max_age=60*60*24*365*2)
            flash('Запись успешно удалена', 'success')
            return res
    except Exception as e:
        db.session.rollback()
        flash(f'Ошибка при удалении: {e}', 'danger')
    return redirect(url_for('index'))

@app.route('/books/<int:book_id>/edit', methods=['GET', 'POST'])
@login_required
@check_rights("edit")
def edit_book(book_id):
    book = db.session.query(Book).filter(Book.id == book_id).scalar()
    genres = db.session.query(Genre).all()
    edited_genres = [str(genre.id) for genre in book.genres]

    if request.method == 'POST':
        if not current_user.can("edit"):
            flash("Недостаточно прав для доступа к странице", "warning")
            return redirect(url_for("index"))
        cur_params = params(PERMITTED_PARAMS)
        for param in cur_params:
            cur_params[param] = bleach.clean(cur_params[param])
        new_genres = request.form.getlist('genre_id')
        try:
            genres_list = []
            for genre in new_genres:
                if int(genre) != 0:
                    new_genre = db.session.query(Genre).filter_by(id=genre).scalar()
                    genres_list.append(new_genre)
            book.genres = genres_list
            book.name = cur_params['name']
            book.short_desc = cur_params['short_desc']
            book.year = cur_params['year']
            book.pub_house = cur_params['pub_house']
            book.author = cur_params['author']
            book.volume = cur_params['volume']
            db.session.commit()
            flash(f"Книга '{book.name}' успешно обновлена", "success")
        except Exception as e:
            db.session.rollback()
            flash(f"При сохранении возникла ошибка: {str(e)}", "danger")
            return render_template("books/edit.html", genres=genres, book=book, new_genres=new_genres)
        return redirect(url_for('show', book_id=book.id))

    return render_template("books/edit.html", genres=genres, book=book, new_genres=edited_genres)

@app.route('/books/<int:book_id>/update', methods=['POST'])
@login_required
@check_rights("edit")
def update_book(book_id):
    if not current_user.can("edit"):
        flash("Недостаточно прав для доступа к странице", "warning")
        return redirect(url_for("index"))
    cur_params = params(PERMITTED_PARAMS)
    for param in cur_params:
        cur_params[param] = bleach.clean(cur_params[param])
    new_genres = request.form.getlist('genre_id[]')
    genres = db.session.query(Genre).all()
    book = db.session.query(Book).filter(Book.id == book_id).scalar()
    try:
        genres_list = []
        for genre in new_genres:
            if int(genre) != 0:
                new_genre = db.session.query(Genre).filter_by(id=genre).scalar()
                genres_list.append(new_genre)
        book.genres = genres_list
        book.name = cur_params['name']
        book.short_desc = cur_params['short_desc']
        book.year = cur_params['year']
        book.pub_house = cur_params['pub_house']
        book.author = cur_params['author']
        book.volume = cur_params['volume']
        db.session.commit()
        flash(f"Книга '{book.name}' успешно обновлена", "success")
    except:
        db.session.rollback()
        flash("При сохранении возникла ошибка", "danger")
        return render_template("books/edit.html", genres=genres, book=book, new_genres=new_genres)
    return redirect(url_for('show', book_id=book.id))

@app.route('/books/<int:book_id>')
def show(book_id):
    try:
        book = db.session.query(Book).filter(Book.id == book_id).scalar()
        book.short_desc = markdown.markdown(book.short_desc)
        user_comment = None
        all_comments = None
        if current_user.is_authenticated:
            user_comment = db.session.query(Comment).filter(Comment.book_id == book_id).filter(Comment.user_id == current_user.id).scalar()
            if user_comment:
                user_comment.text = markdown.markdown(user_comment.text)
            all_comments = db.session.execute(db.select(Comment).filter(Comment.book_id == book_id, Comment.user_id != current_user.id)).scalars()
        else:
            all_comments = db.session.execute(db.select(Comment).filter(Comment.book_id == book_id)).scalars()
        
        markdown_all_comments = []
        for comment in all_comments:
            markdown_all_comments.append({
                'get_user': comment.get_user,
                'mark': comment.mark,
                'text': markdown.markdown(comment.text)
            })
        genres = book.genres
        if not request.cookies.get('viewed_books'):
            res = make_response(render_template('books/show.html', book=book, genres=genres, comment=user_comment, all_comments=markdown_all_comments))
            res.set_cookie('viewed_books', str(book_id), max_age=60*60*24*365*2)
        else:
            res = make_response(render_template('books/show.html', book=book, genres=genres, comment=user_comment, all_comments=markdown_all_comments))
            book_ids = request.cookies.get('viewed_books').split(',')
            if len(book_ids) == 5 and str(book_id) not in book_ids:
                book_ids.pop()
            new_book_ids = str(book_id)
            if str(book_id) not in book_ids:
                new_book_ids = new_book_ids + ',' + ','.join(book_ids)
            else:
                viewed_book_ids = [new_book_ids]
                for id in book_ids:
                    if id not in viewed_book_ids:
                        viewed_book_ids.append(id)
                new_book_ids = ','.join(viewed_book_ids)
            res.set_cookie('viewed_books', new_book_ids, max_age=60*60*24*365*2)
        return res
    except:
        flash('Ошибка при загрузке данных', 'danger')
        return redirect(url_for('index'))

if __name__ == '__main__':
    app.run()
