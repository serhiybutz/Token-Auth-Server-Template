import Vapor
import Fluent

final class Book: Model {

    static let schema = "books"

    @ID
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "author")
    var author: String

    @Parent(key: "userID")
    var user: User

    @Timestamp(key: "createdAt", on: .create)
    var createdAt

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt

    @Siblings(through: BookGenrePivot.self, from: \.$book, to: \.$genre)
    var genres: [Genre]

    init() {}

    init(id: UUID? = nil, title: String, author: String, userID: User.IDValue) {
        
        self.id = id
        self.title = title
        self.author = author
        self.$user.id = userID
    }
}

extension Book: Content {}
