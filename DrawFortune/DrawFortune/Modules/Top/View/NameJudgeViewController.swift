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
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(text)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        closeButton.addTarget(self, action: #selector(closeModal(_ :)), for: .touchUpInside)
    }
    
    // MARK: private
    
    private lazy var text: UILabel = {
        let view = UILabel()
        view.frame.size.width = 200
        view.frame.size.height = 100
        view.textColor = .blue
        view.text = "This is next page"
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("X", for: .normal)
        return view
    }()
    
    @objc private func closeModal(_ sender: UIButton ) {
        self.dismiss(animated: true, completion: nil)
    }
}
