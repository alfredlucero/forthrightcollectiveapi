import { QueryResult } from "pg";
import { pool } from "../dbPool";

export interface Book {
  id: number;
  author: string;
  title: string;
}

const booksTable = "books";

const BooksService = {
  getBooks: (): Promise<QueryResult<Book>> => {
    return pool.query<Book>(`SELECT * FROM ${booksTable}`);
  },

  getBookById: (bookId: number): Promise<QueryResult<Book>> => {
    return pool.query<Book, [number]>(`SELECT * FROM ${booksTable} WHERE id = $1`, [bookId]);
  },

  createBook: (bookToCreate: Omit<Book, "id">): Promise<QueryResult<Book>> => {
    return pool.query<Book, [string, string]>(`INSERT INTO ${booksTable} (author, title) VALUES ($1, $2) RETURNING *`, [
      bookToCreate.author,
      bookToCreate.title,
    ]);
  },

  updateBookById: (updatedBook: Book): Promise<QueryResult<Book>> => {
    return pool.query<Book, [string, string, number]>(
      `UPDATE ${booksTable} SET author = $1, title = $2 WHERE id = $3 RETURNING *`,
      [updatedBook.author, updatedBook.title, updatedBook.id],
    );
  },

  deleteBookById: (bookId: number): Promise<QueryResult<Book>> => {
    return pool.query<Book, [number]>(`DELETE FROM ${booksTable} WHERE id = $1 RETURNING *`, [bookId]);
  },
};

export default BooksService;
