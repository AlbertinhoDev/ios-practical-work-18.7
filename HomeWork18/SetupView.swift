import Foundation
import SnapKit

class SetupView {
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
}
