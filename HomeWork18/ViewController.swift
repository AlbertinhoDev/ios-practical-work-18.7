import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {

    lazy var textField: UITextField = {
        let text = UITextField()
        text.placeholder = "Какой фильм интересует"
        text.borderStyle = .roundedRect
        return text
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 20
        view.addArrangedSubview(buttonURL)
        view.addArrangedSubview(buttonAlamofire)
        return view
    }()
    
    private lazy var buttonURL: UIButton = {
        let button = UIButton()
        button.setTitle("URLSession", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var buttonAlamofire: UIButton = {
        let button = UIButton()
        button.setTitle("Alamofire", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.isEditable = false
        textView.textColor = UIColor.black
        textView.text = "Тут будет результат"
        return textView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: .large)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonURL.addTarget(self, action: #selector(chechSession(sender:)), for: .touchUpInside)
        buttonAlamofire.addTarget(self, action: #selector(chechAlamofire(sender:)), for: .touchUpInside)
        
        view.addSubview(textField)
        view.addSubview(textView)
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        setupConstraints()

    }
    
    @objc func chechSession(sender: UIButton) {
        if self.textField.text!.trimmingCharacters(in: .whitespaces).isEmpty == false {
            let text = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(self.textField.text!.lowercased())"
            sessionPressed(text: text)
        }
    }
    
    @objc func chechAlamofire(sender: UIButton) {
        if self.textField.text!.trimmingCharacters(in: .whitespaces).isEmpty == false {
            let text = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(self.textField.text!.lowercased())"
            alamofirePressed(text: text)
        }
    }
    
    
    
    private func sessionPressed(text: String){
        self.activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            sleep(1)
            var myData = Quere()
            let url = URL(string: text)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields =  ["X-API-KEY" : "5a1aa54a-2e6d-40b4-aa36-e6950cc441ee"]
            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
                guard error == nil else {
                    print("При запросе возникла ошибка")
                    return
                }
                do {
                    myData = try JSONDecoder().decode(Quere.self, from: data!)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        self.activityIndicator.stopAnimating()
                        let counts = myData.films.count
                        if counts > 0 {
                            var description = ""
                            for i in 0...counts - 1 {
                                description += "Название фильма: \(myData.films[i].nameRu.uppercased())" + " (\(myData.films[i].nameEn.uppercased()))" + "\n" + "Тип фильма: \(myData.films[i].type)" + "\n" + "Год выпуска: \(myData.films[i].year)" + "\n" + "Описание:  \(myData.films[i].description)"  + "\n" + "Рейтинг: \(myData.films[i].rating)" + "\n" + "\n"
                            }
                            self.textView.text = description
                        }else{
                            print("Фильм не найден")
                        }
                    }
                }catch{
                    print(error)
                }
            }
            task.resume()
        }
    
    }
    
    private func alamofirePressed(text: String){
        self.activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            sleep(1)
            NetWorkWithAlamofire.shared.fetchData(text: "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(self.textField.text!.lowercased())") { result in
                switch result{
                    
                case .success(let filmResults):
                    let myData = filmResults
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        self.activityIndicator.stopAnimating()
                        let counts = myData.films.count
                        if counts > 0 {
                            var description = ""
                            for i in 0...counts - 1 {
                                description += "Название фильма: \(myData.films[i].nameRu.uppercased())" + " (\(myData.films[i].nameEn.uppercased()))" + "\n" + "Тип фильма: \(myData.films[i].type)" + "\n" + "Год выпуска: \(myData.films[i].year)" + "\n" + "Описание:  \(myData.films[i].description)"  + "\n" + "Рейтинг: \(myData.films[i].rating)" + "\n" + "\n"
                            }
                            self.textView.text = description
                        }else{
                            print("Фильм не найден")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview().inset(20)
        }
        stackView.snp.makeConstraints {make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalTo(textField.snp.topMargin).inset(50)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.topMargin).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.left.right.equalToSuperview().inset(20)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerXWithinMargins.equalTo(self.view)
            make.centerYWithinMargins.equalTo(self.view)
        }
    }
}

