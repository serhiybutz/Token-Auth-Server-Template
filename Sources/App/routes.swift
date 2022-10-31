import Fluent
import Vapor

func routes(_ app: Application) throws {

    let usersController = UsersController()
    try app.register(collection: usersController)

    let booksController = BooksController()
    try app.register(collection: booksController)
}
