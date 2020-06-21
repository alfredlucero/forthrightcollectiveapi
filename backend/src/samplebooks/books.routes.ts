import { Router, Request, Response } from "express";
import BooksService, { Book } from "./books.service";
import { Dto } from "../types/dto";

export type GetBooksDto = Dto<Book[]>;
export type GetBookByIdDto = Dto<Book>;
export type CreateBookDto = Dto<Book>;
export type UpdateBookByIdDto = Dto<Book>;
export type DeleteBookByIdDto = Dto<Book>;

const BooksRoutes = {
  path: "/sample/books",
  initializeRoutes(): Router {
    const router = Router();

    router.get("/", async (req: Request, res: Response) => {
      try {
        const results = await BooksService.getBooks();
        console.log("Get Books Results", results);
        const getBooksDto: GetBooksDto = {
          data: results.rows,
        };
        res.status(200).json(getBooksDto);
      } catch (e) {
        res.status(500).json({ message: `Failed to retrieve books due to some reason: ${e.stack}` });
      }
    });

    router.get("/:bookId", async (req: Request, res: Response) => {
      const bookId = parseInt(req.params.bookId, 10);
      try {
        const result = await BooksService.getBookById(bookId);
        console.log("Get Book by Id Result", result);

        if (result.rows.length === 0) {
          res.status(404).json({ message: "Book id not found" });
        } else {
          const getBookByIdDto: GetBookByIdDto = {
            data: result.rows[0],
          };
          res.status(200).json(getBookByIdDto);
        }
      } catch (e) {
        res.status(500).json({ message: `Failed to retrieve book by id due to some reason: ${e.stack}` });
      }
    });

    router.post("/", async (req: Request, res: Response) => {
      const { author, title } = req.body;
      const bookToCreate: Omit<Book, "id"> = {
        author,
        title,
      };

      try {
        const result = await BooksService.createBook(bookToCreate);
        console.log("Create Book Result", result);

        const createBookDto: CreateBookDto = {
          data: result.rows[0],
        };

        res.status(201).json(createBookDto);
      } catch (e) {
        res.status(500).json({ message: `Failed to create book due to some reason: ${e.stack}` });
      }
    });

    router.put("/:bookId", async (req: Request, res: Response) => {
      const bookId = parseInt(req.params.bookId, 10);
      const { author, title } = req.body;
      const updatedBook: Book = {
        id: bookId,
        author,
        title,
      };

      try {
        const result = await BooksService.updateBookById(updatedBook);
        console.log("Update book by id result", result);

        if (result.rows.length === 0) {
          res.status(404).json({ message: "No matching book id" });
        } else {
          const updateBookByIdDto: UpdateBookByIdDto = {
            data: result.rows[0],
          };
          res.status(200).json(updateBookByIdDto);
        }
      } catch (e) {
        res.status(500).json({ message: `Failed to update book by id for some reason ${e.stack}` });
      }
    });

    router.delete("/:bookId", async (req: Request, res: Response) => {
      const bookId = parseInt(req.params.bookId, 10);

      try {
        const result = await BooksService.deleteBookById(bookId);
        console.log("Delete book by id result", result);

        if (result.rows.length === 0) {
          res.status(404).json({ message: "No matching book id" });
        } else {
          const deleteBookByIdDto: DeleteBookByIdDto = {
            data: result.rows[0],
          };
          res.status(200).json(deleteBookByIdDto);
        }
      } catch (e) {
        res.status(500).json({ message: `Failed to delete book by id for some reason ${e.stack}` });
      }
    });

    return router;
  },
};

export default BooksRoutes;
