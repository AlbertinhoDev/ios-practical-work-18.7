import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    let apiKeys = ["X-API-KEY" : "5a1aa54a-2e6d-40b4-aa36-e6950cc441ee"]
    
    private lazy var textField: UITextField = {
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
        
        textField.delegate = self
        
        buttonURL.addTarget(self, action: #selector(sessionPressed(sender:)), for: .touchUpInside)
        buttonAlamofire.addTarget(self, action: #selector(alamofirePressed(sender:)), for: .touchUpInside)
        
        view.addSubview(textField)
        view.addSubview(textView)
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        setupConstraints()
        
    }
    
    private func textViewData() -> String {
        let text = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(self.textField.text!.lowercased().addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")"
        return text
    }
    
    @objc func sessionPressed(sender: UIButton) {
        if self.textField.text!.trimmingCharacters(in: .whitespaces).isEmpty == false {
            let text = textViewData()
            sessionProcess(text: text)
        }
    }
    
    @objc func alamofirePressed(sender: UIButton) {
        if self.textField.text!.trimmingCharacters(in: .whitespaces).isEmpty == false {
            let text = textViewData()
            alamofireProcess(text: text)
        }
    }
    
    private func sessionProcess(text: String){
        self.activityIndicator.startAnimating()
            var myData = Quere()
            let url = URL(string: text)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = self.apiKeys
            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
                guard error == nil else {
                    print("При запросе возникла ошибка")
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                    }
                    return
                }
                do {
                    myData = try JSONDecoder().decode(Quere.self, from: data!)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        self.activityIndicator.stopAnimating()
                        let maxCount = myData.films.count
                        if maxCount > 0 {
                            self.textView.text = showData(maxCount: maxCount, myData: myData)
                        }else{
                            print("Фильм не найден")
                        }
                    }
                }catch{
                    print("Проблема с запросом/декодом")
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
            task.resume()
//        }
    
    }
    
    private func alamofireProcess(text: String){
        self.activityIndicator.startAnimating()
        let film = text
            NetWorkWithAlamofire.shared.fetchData(text: film, apiKeys: self.apiKeys, activityIndicator: self.activityIndicator) { result in
                switch result{
                case .success(let filmResults):
                    let myData = filmResults
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        self.activityIndicator.stopAnimating()
                        let maxCount = myData.films.count
                        if maxCount > 0 {
                            self.textView.text = showData(maxCount: maxCount, myData: myData)
                        }
                    }
                case .failure(_):
                    self.activityIndicator.stopAnimating()
                    return
                }
            }

    }
    
    private func showData(maxCount : Int, myData: Quere) -> String {
        var description = ""
        for i in 0...maxCount - 1 {
            var ruName = unwrap(string: myData.films[i].nameRu?.uppercased())
            var enName = unwrap(string: myData.films[i].nameEn?.uppercased())
            var type = myData.films[i].type
            var year = myData.films[i].year
            var desc = unwrap(string: myData.films[i].description)
            var rating = myData.films[i].rating
            
            description += "Название фильма: \(ruName)" + " (\(enName)" + "\n" + "Тип фильма: \(type)" + "\n" + "Год выпуска: \(year)" + "\n" + "Описание: \(desc))"  + "\n" + "Рейтинг: \(rating)" + "\n" + "\n"
            }
        
        return description
    }
    
    private func unwrap(string : String?) -> String{
        guard let string = string else {return ""}
        return string
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

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
