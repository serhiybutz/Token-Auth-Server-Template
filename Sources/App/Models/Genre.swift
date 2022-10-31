import Fluent
import Vapor

final class Genre: Model, Content {

    static let schema = "genres"

    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Siblings(through: BookGenrePivot.self, from: \.$genre, to: \.$book)
    var books: [Book]

    init() {}

    init(id: UUID? = nil, name: String) {

        self.id = id
        self.name = name
    }
}

extension Genre {

    static func addGenre(_ name: String, to book: Book, on req: Request) -> EventLoopFuture<Void> {

        Genre.query(on: req.db)
            .filter(\.$name == name)
            .first()
            .flatMap { foundGenre in

                if let existingGenre = foundGenre {
                    return book.$genres
                        .attach(existingGenre, on: req.db)
                } else {
                    let genre = Genre(name: name)
                    return genre.save(on: req.db).flatMap {
                        book.$genres
                            .attach(genre, on: req.db)
                    }
                }
            }
    }
}
