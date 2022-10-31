import Fluent
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) throws {

     app.middleware.use(
        FileMiddleware(publicDirectory: app.directory.publicDirectory)
     )

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateBook())
    app.migrations.add(CreateGenre())
    app.migrations.add(CreateBookGenrePivot())
    app.migrations.add(CreateToken())

    app.migrations.add(SeedDemoDB())

    app.http.server.configuration.hostname = "0.0.0.0"

    app.logger.logLevel = .debug

    try app.autoMigrate().wait()

    try routes(app)
}
