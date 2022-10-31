import Fluent
import FluentSQL
import Vapor

struct UsersController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {

        let usersRoute = routes.grouped("api", "users")

        usersRoute.get("exists", use: existsHandler)

        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = usersRoute.grouped(basicAuthMiddleware)

        basicAuthGroup.post("signup", use: signUpHandler)
        basicAuthGroup.post("signin", use: signInHandler)
    }

    func existsHandler(_ req: Request) throws -> EventLoopFuture<Bool> {

        guard let usernameTerm = req.query[String.self, at: "username"] else {
            throw Abort(.badRequest)
        }

        let isCaseSensitive = req.query[String.self, at: "case_sensitive"]
            .map({ $0.boolValue }) ?? false

        precondition(req.db is SQLDatabase, "Not supported")
        return User.query(on: req.db)
            .ifCond(
                isCaseSensitive,
                then: { query in
                    query.filter(\.$username == usernameTerm)
                },
                otherwise: { query in
                    query.filter(.sql(raw: "LOWER(username) = LOWER('\(usernameTerm)')"))
                })
            .count()
            .map { $0 > 0 }
    }

    func signUpHandler(_ req: Request) throws -> EventLoopFuture<AuthGrantedResponse> {

        let user = try User(from: try req.content.decode(NewUserRequest.self))
        return user.save(on: req.db)
            .flatMapThrowing { () throws -> Token in
                try Token.generate(for: user)
            }
            .flatMap { token in
                token.save(on: req.db).map { _ in
                    AuthGrantedResponse(
                        token: token.value,
                        profile: AuthGrantedResponse.UserProfile(
                            fullname: user.fullname,
                            email: user.email,
                            phone: user.phone,
                            avatar: user.avatar.flatMap(URL.init(string:))
                        )
                    )
                }
            }
    }

    func signInHandler(_ req: Request) throws -> EventLoopFuture<AuthGrantedResponse> {

        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req.db).map { _ in
            AuthGrantedResponse(
                token: token.value,
                profile: AuthGrantedResponse.UserProfile(
                    fullname: user.fullname,
                    email: user.email,
                    phone: user.phone,
                    avatar: user.avatar.flatMap(URL.init(string:))
                )
            )
        }
    }
}
