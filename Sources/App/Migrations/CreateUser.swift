import Fluent

struct CreateUser: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {

        database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("passwordHash", .string, .required)
            .field("fullname", .string, .required)
            .field("email", .string)
            .field("phone", .string)
            .field("avatar", .string)
            .field("createdAt", .datetime)
            .field("updatedAt", .datetime)
            .unique(on: "username")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {

        database.schema("users").delete()
    }
}
