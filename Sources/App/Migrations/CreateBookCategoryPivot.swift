import Fluent

struct CreateBookGenrePivot: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {

        database.schema("book-genre-pivot")
            .id()
            .field("bookID", .uuid, .required, .references("books", "id", onDelete: .cascade))
            .field("genreID", .uuid, .required, .references("genres", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {

        database.schema("book-genre-pivot").delete()
    }
}
