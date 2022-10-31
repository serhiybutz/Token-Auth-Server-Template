import Fluent

struct CreateGenre: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {

        database.schema("genres")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("genres").delete()
    }
}
