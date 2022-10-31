import Fluent
import Vapor

final class User: Model, Content {

    static let schema = "users"

    @ID
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "passwordHash")
    var passwordHash: String

    @Field(key: "fullname")
    var fullname: String

    @OptionalField(key: "email")
    var email: String?

    @OptionalField(key: "phone")
    var phone: String?

    @OptionalField(key: "avatar")
    var avatar: String?

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    @Children(for: \.$user)
    var books: [Book]

    init() {}

    init(id: UUID? = nil, username: String, passwordHash: String, fullname: String, email: String? = nil, phone: String? = nil, avatar: String? = nil) {

        self.id = id
        self.username = username
        self.passwordHash = passwordHash
        self.fullname = fullname
        self.email = email
        self.phone = phone
        self.avatar = avatar
    }
}

extension User {

    convenience init(from source: NewUserRequest) throws {
        self.init(
            username: source.username,
            passwordHash: try Bcrypt.hash(source.password),
            fullname: source.fullname,
            email: source.email,
            phone: source.phone)
    }
}

extension User: ModelAuthenticatable {

    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User: ModelSessionAuthenticatable {}
extension User: ModelCredentialsAuthenticatable {}
