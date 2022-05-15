import UIKit

class NameJudgeViewController: UIViewController {
            
    // MARK: override

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        buttonForAbove.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(text)
        view.addSubview(buttonForAbove)
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            buttonForAbove.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonForAbove.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10),
            buttonForAbove.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -100),
        ])
    }
    
    // MARK: private
    
    private lazy var text: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "Please enter your name"
        return view
    }()
    
    private lazy var buttonForAbove: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Send", for: .normal)
        return view
    }()
}
