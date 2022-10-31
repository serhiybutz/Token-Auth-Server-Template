import Vapor
import Fluent

struct NewUserRequest: Content {

    var username: String
    var password: String
    var fullname: String
    var email: String?
    var phone: String?
}

struct AuthGrantedResponse: Content {

    struct UserProfile: Content {
        
        let fullname: String
        let email: String?
        let phone: String?
        let avatar: URL?
    }

    let token: String
    let profile: UserProfile

    init(token: String, profile: UserProfile) {

        self.token = token
        self.profile = profile
    }
}

struct GenreResponse: Content {

    var id: UUID
    var name: String

    init(from source: Genre) {
        self.id = source.id!
        self.name = source.name
    }
}


struct NewBookRequest: Content {

    let title: String
    let author: String
}

struct BookResponse: Content {

    var id: UUID
    var title: String
    var author: String
    var genres: [GenreResponse]

    init(from source: Book) {

        self.id = source.id!
        self.title = source.title
        self.author = source.author
        self.genres = source.genres.map(GenreResponse.init(from:))
    }

    init(id: UUID, title: String, author: String, genres: [GenreResponse]) {

        self.id = id
        self.title = title
        self.author = author
        self.genres = genres
    }
}
