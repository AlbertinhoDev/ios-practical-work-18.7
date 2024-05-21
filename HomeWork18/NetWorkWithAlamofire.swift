import Alamofire
import Foundation

class NetWorkWithAlamofire {
    static let shared = NetWorkWithAlamofire()
    private init () {}
    
    func fetchData(text: String, completion: @escaping (Result < Quere, Error>) -> ()) {
        
        let url = URL(string: text)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-API-KEY" : "5a1aa54a-2e6d-40b4-aa36-e6950cc441ee"]
        
        AF.request(request)
            .validate()
            .response { response in
                guard let data = response.data else {
                    if let error = response.error {
                        completion(.failure(error))
                        print(error)
                    }
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let filmResults = try? decoder.decode(Quere.self, from: data) else {
                    return
                }
                completion(.success(filmResults))
            }
    }
}

