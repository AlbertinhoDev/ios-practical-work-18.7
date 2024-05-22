import Alamofire
import Foundation

class NetWorkWithAlamofire {
    static let shared = NetWorkWithAlamofire()
    private init () {}
    
    func fetchData(text: String, apiKeys : [String:String], activityIndicator : UIActivityIndicatorView,  completion: @escaping (Result < Quere, Error>) -> ()) {
        
        let url = URL(string: text)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = apiKeys
        
        AF.request(request)
            .validate()
            .response { response in
                guard let data = response.data else {
                    if let error = response.error {
                        completion(.failure(error))
                        print("При запросе возникла ошибка")
                    }
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let filmResults = try? decoder.decode(Quere.self, from: data) else {
                    print("Фильм не найден")
                    activityIndicator.stopAnimating()
                    return
                }
                completion(.success(filmResults))
            }
    }
}



