import UIKit

class ViewController: UIViewController {
            
    // MARK: override

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.translatesAutoresizingMaskIntoConstraints = false
        circle.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circle)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 100),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        button.addTarget(self, action: #selector(getFortune(_ :)), for: .touchUpInside)
    }
    
    // MARK: private
        
    private lazy var circle: UILabel = {
        let view = UILabel()
        view.backgroundColor = .red
//        view.layer.cornerRadius = view.bounds.width / 2
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
    
    @objc private func getFortune(_ sender: UIButton) {
        let fortune = ["大吉", "吉", "中吉", "凶"]
        let random = arc4random_uniform(UInt32(fortune.count))
        self.circle.text = fortune[Int(random)]
    }
}
