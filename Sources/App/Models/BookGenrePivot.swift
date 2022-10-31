import Fluent
import Foundation

final class BookGenrePivot: Model {
    
    static let schema = "book-genre-pivot"

    @ID
    var id: UUID?

    @Parent(key: "bookID")
    var book: Book

    @Parent(key: "genreID")
    var genre: Genre

    init() {}

    init(id: UUID? = nil, book: Book, genre: Genre) throws {

        self.id = id
        self.$book.id = try book.requireID()
        self.$genre.id = try genre.requireID()
    }
}
