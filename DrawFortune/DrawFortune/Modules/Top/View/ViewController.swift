import UIKit

class ViewController: UIViewController {
            
    // MARK: override

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        buttonForAbove.translatesAutoresizingMaskIntoConstraints = false
        circle.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(text)
        view.addSubview(buttonForAbove)
        view.addSubview(circle)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            buttonForAbove.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonForAbove.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 10),
            buttonForAbove.bottomAnchor.constraint(equalTo: circle.topAnchor, constant: -100),
            circle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 100),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        buttonForAbove.addTarget(self, action: #selector(openNextPage(_ :)), for: .touchUpInside)
        button.addTarget(self, action: #selector(getFortune(_ :)), for: .touchUpInside)
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
        
    private lazy var circle: PaddingLabel = {
        let view = PaddingLabel()
        view.padding = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
        view.frame.size.width = 200
        view.frame.size.height = 200
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = 100
        view.textColor = .white
        view.text = "Fortune"
        return view
    }()

    private lazy var button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .darkGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Draw a Fortune", for: .normal)
        return view
    }()
        
    @objc private func openNextPage(_ sender: UIButton) {
        guard let inputText = text.text else { return }
        if (inputText == "") {
            let alertController = UIAlertController(title: "名前入力欄が空です", message: "名前を1文字以上入力してください", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        } else {
            present(NameJudgeViewController(inputText), animated: true, completion: nil)
        }
    }

    @objc private func getFortune(_ sender: UIButton) {
        let fortune = ["大吉", "吉", "中吉", "凶"]
        let random = Int.random(in: 1...fortune.count)
        self.circle.text = fortune[Int(random)]
    }
}
