import Vapor
import Fluent

struct BooksController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {

        let booksRoutes = routes.grouped("api", "books")

        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = booksRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        tokenAuthGroup.get(use: getAllHandler)
        tokenAuthGroup.get(":bookID", use: getHandler)

        tokenAuthGroup.post(use: createHandler)
        tokenAuthGroup.delete(":bookID", use: deleteHandler)
        tokenAuthGroup.put(":bookID", use: updateHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[BookResponse]> {

        let user = try req.auth.require(User.self)
        let userID = try user.requireID()

        let filterTerm: String? = {
            guard var result = try? req.query.get(String.self, at: "filter") else { return nil }
            result = result.trimmingCharacters(in: .whitespacesAndNewlines)
            return result.isEmpty
                ? nil
                : result
        }()

        let sortField: SortField? = (try? req.query.get(String.self, at: "sort_field"))
            .flatMap { SortField.init($0) }
        let sortDirection: DatabaseQuery.Sort.Direction = (try? req.query.get(String.self, at: "sort_direction"))
            .flatMap(DatabaseQuery.Sort.Direction.init) ?? .ascending

        return Book
            .query(on: req.db)
            .filter(\.$user.$id == userID)
            .ifLet(
                filterTerm,
                then: { query, filterTerm in
                    query.group(.or) { or in
                        or.filter(\.$title ~~ filterTerm)
                        or.filter(\.$author ~~ filterTerm)
                    }
                })
            .chain { query in
                switch sortField {
                case .title?:
                    return query.sort(\.$title, sortDirection)
                case .author?:
                    return query.sort(\.$author, sortDirection)
                case nil:
                    return query
                }
            }
            .with(\.$genres)
            .all()
            .map { $0.map(BookResponse.init(from:)) }
    }

    func getHandler(_ req: Request) -> EventLoopFuture<BookResponse> {

        Book
            .find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .map(BookResponse.init(from:))
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Book> {

        let data = try req.content.decode(NewBookRequest.self)
        let user = try req.auth.require(User.self)
        let book = try Book(title: data.title, author: data.author, userID: user.requireID())
        return book.save(on: req.db).map { book }
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Book> {

        let updateData = try req.content.decode(NewBookRequest.self)
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { book in
                book.title = updateData.title
                book.author = updateData.author
                book.$user.id = userID
                return book.save(on: req.db).map {
                    book
                }
            }
    }

    func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {

        Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                book.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }

    enum SortField: String {

        case title, author
        init?(_ str: String) {
            guard let new = Self.init(rawValue: str.lowercased()) else { return nil }
            self = new
        }
    }
}
