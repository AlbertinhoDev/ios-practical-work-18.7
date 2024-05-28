import Foundation

struct Quere: Decodable {
    var keyword: String = ""
    var pagesCount: Int?
    var films: [Films] = []
}

struct Films: Decodable {
    var nameRu: String?
    var nameEn: String?
    var type: String
    var year: String
    var description: String?
    var rating: String
}

