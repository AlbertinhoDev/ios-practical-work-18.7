//import Foundation
//import UIKit
//
//struct Session {
//    
//    func loadData(text: String){
//        
//        var text = "lost"
//        var t = ""
//        
//        let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(text)")!
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields =  ["X-API-KEY" : "5a1aa54a-2e6d-40b4-aa36-e6950cc441ee"]
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("При запросе возникла ошибка")
//                return
//            }else if let data = data, let _ = try? JSONSerialization.jsonObject(with: data, options: []) {
//                let convertedString = String(data: data, encoding: .utf8)
//                t = convertedString!
//            }
//        }
//        task.resume()
//        print(t)
//    }
//}
//
//
//
//
//
//
//
//
//struct Session2 {
//    func loadData(text: String){
//        var myData = Quere()
//        let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(text)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields =  ["X-API-KEY" : "5a1aa54a-2e6d-40b4-aa36-e6950cc441ee"]
//        
//        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
//            guard error == nil else {
//                print("При запросе возникла ошибка")
//                return
//            }
//            do {
//                myData = try JSONDecoder().decode(Quere.self, from: data!)
//            }catch{
//                print(error)
//            }
//            
//        }
//        task.resume()
//    }
//}
