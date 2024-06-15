"""change image, books

Revision ID: b19b29a8c2f3
Revises: dd6be9677d03
Create Date: 2023-06-19 14:04:59.716579

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = 'b19b29a8c2f3'
down_revision = 'dd6be9677d03'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('books', schema=None) as batch_op:
        batch_op.add_column(sa.Column('image_id', sa.String(length=100), nullable=True))
        batch_op.create_foreign_key(batch_op.f('fk_books_image_id_images'), 'images', ['image_id'], ['id'])

    with op.batch_alter_table('images', schema=None) as batch_op:
        batch_op.drop_constraint('fk_images_book_id_books', type_='foreignkey')
        batch_op.drop_column('book_id')

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('images', schema=None) as batch_op:
        batch_op.add_column(sa.Column('book_id', mysql.INTEGER(display_width=11), autoincrement=False, nullable=True))
        batch_op.create_foreign_key('fk_images_book_id_books', 'books', ['book_id'], ['id'])

    with op.batch_alter_table('books', schema=None) as batch_op:
        batch_op.drop_constraint(batch_op.f('fk_books_image_id_images'), type_='foreignkey')
        batch_op.drop_column('image_id')

    # ### end Alembic commands ###
