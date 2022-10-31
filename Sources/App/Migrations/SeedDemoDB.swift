import Fluent
import Vapor

struct SeedDemoDB: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {

        do {

            let users = [
                User(username: "alice", passwordHash: try Bcrypt.hash("alice"), fullname: "Alice"),
                User(username: "bob", passwordHash: try Bcrypt.hash("bob"), fullname: "Bob"),
            ]

            var genres: [Genre] = []
            var books: [Book] = []
            var bookGenrePivots: [BookGenrePivot] = []

            return users.create(on: database)
                .flatMap {
                    
                    genres = [
                        Genre(name: "Novella"),
                        Genre(name: "Novel"),
                        Genre(name: "Self-help"),
                        Genre(name: "Historical fiction"),
                        Genre(name: "War novel"),
                        Genre(name: "Mystery"),
                        Genre(name: "Horror fiction"),
                        Genre(name: "Magic realism"),
                        Genre(name: "Absurd"),
                        Genre(name: "Popular science"),
                        Genre(name: "Anthropology"),
                        Genre(name: "Astrophysics"),
                        Genre(name: "Cosmology"),
                        Genre(name: "Philosophy"),
                        Genre(name: "History"),
                        Genre(name: "Classics"), // 15
                        Genre(name: "Fiction"),
                        Genre(name: "Literature"),
                        Genre(name: "Mythology"),
                        Genre(name: "Fairy Tales"),
                        Genre(name: "Adventure"),
                        Genre(name: "Folklore"),
                        Genre(name: "Fantasy"),
                        Genre(name: "Children's literature"),
                    ]

                    return genres.create(on: database)
                }
                .flatMap {

                    books = [
                        Book(title: "Jonathan Livingston Seagull", author: "Richard Bach", userID: users[0].id!),
                        Book(title: "The Ginger Man", author: "J. P. Donleavy", userID: users[1].id!),
                        Book(title: "All the Light We Cannot See", author: "Anthony Doerr", userID: users[0].id!),
                        Book(title: "The Name of the Rose", author: "Umberto Eco", userID: users[0].id!),
                        Book(title: "Perfume", author: "Patrick Süskind", userID: users[0].id!),
                        Book(title: "Cosmos", author: "Carl Sagan", userID: users[1].id!),
                        Book(title: "Republic", author: "Plato", userID: users[1].id!),
                        Book(title: "Ulysses", author: "James Joyce", userID: users[0].id!),
                        Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", userID: users[0].id!),
                        Book(title: "Ulysses", author: "James Joyce", userID: users[0].id!),
                        Book(title: "The Arabian Nights", author: "Anonymous", userID: users[0].id!),
                        Book(title: "Alice’s Adventures in Wonderland", author: "Lewis Carroll", userID: users[0].id!),
                    ]

                    return books.create(on: database)
                }
                .flatMap {

                    bookGenrePivots = [
                        try! BookGenrePivot(book: books[0], genre: genres[0]),
                        try! BookGenrePivot(book: books[0], genre: genres[2]),
                        try! BookGenrePivot(book: books[1], genre: genres[1]),
                        try! BookGenrePivot(book: books[2], genre: genres[3]),
                        try! BookGenrePivot(book: books[2], genre: genres[4]),
                        try! BookGenrePivot(book: books[3], genre: genres[3]),
                        try! BookGenrePivot(book: books[3], genre: genres[5]),
                        try! BookGenrePivot(book: books[4], genre: genres[5]),
                        try! BookGenrePivot(book: books[4], genre: genres[6]),
                        try! BookGenrePivot(book: books[4], genre: genres[7]),
                        try! BookGenrePivot(book: books[4], genre: genres[8]),
                        try! BookGenrePivot(book: books[5], genre: genres[9]),
                        try! BookGenrePivot(book: books[5], genre: genres[10]),
                        try! BookGenrePivot(book: books[5], genre: genres[11]),
                        try! BookGenrePivot(book: books[5], genre: genres[12]),
                        try! BookGenrePivot(book: books[5], genre: genres[13]),
                        try! BookGenrePivot(book: books[5], genre: genres[14]),
                        try! BookGenrePivot(book: books[6], genre: genres[13]),
                        try! BookGenrePivot(book: books[7], genre: genres[1]),
                        try! BookGenrePivot(book: books[8], genre: genres[1]),
                        try! BookGenrePivot(book: books[9], genre: genres[16]),
                        try! BookGenrePivot(book: books[9], genre: genres[17]),
                        try! BookGenrePivot(book: books[9], genre: genres[18]),
                        try! BookGenrePivot(book: books[9], genre: genres[19]),
                        try! BookGenrePivot(book: books[9], genre: genres[20]),
                        try! BookGenrePivot(book: books[9], genre: genres[21]),
                        try! BookGenrePivot(book: books[10], genre: genres[22]),
                        try! BookGenrePivot(book: books[10], genre: genres[23]),
                        try! BookGenrePivot(book: books[10], genre: genres[16]),
                        try! BookGenrePivot(book: books[10], genre: genres[8]),
                    ]

                    return bookGenrePivots.create(on: database)
                }

        } catch {
            return database.eventLoop.future(error: error)
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {

        BookGenrePivot.query(on: database).delete()
            .flatMap {
                Book.query(on: database).delete()
            }
            .flatMap {
                Genre.query(on: database).delete()
            }
            .flatMap {
                User.query(on: database).delete()
            }
    }
}
