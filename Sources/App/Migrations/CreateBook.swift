import Fluent

struct CreateBook: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {

        database.schema("books")
            .id()
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .field("createdAt", .datetime)
            .field("updatedAt", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {

        database.schema("books").delete()
    }
}
