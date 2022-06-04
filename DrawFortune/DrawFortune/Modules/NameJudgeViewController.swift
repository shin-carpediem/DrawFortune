import UIKit

final class NameJudgeViewController: UIViewController {
    var userName: String
    
    init(_ userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: override

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
            
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: private
    
    private lazy var text: UILabel = {
        let view = UILabel()
        view.frame.size.width = 200
        view.frame.size.height = 100
        view.textColor = .black
        view.text = "\(userName)'s score is..."
        return view
    }()
    
    private let score: UILabel = {
        let view = UILabel()
        view.frame.size.width = 200
        view.frame.size.height = 100
        view.textColor = .blue
        view.text = String(Int.random(in: 1...100))
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("X", for: .normal)
        view.addTarget(self, action: #selector(closeModal(_ :)), for: .touchUpInside)
        return view
    }()
    
    private func setupLayout() {
        view.backgroundColor = .white

        view.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        score.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(text)
        view.addSubview(score)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            text.bottomAnchor.constraint(equalTo: score.topAnchor, constant: -10),
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            score.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            score.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func closeModal(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        guard let presentationController = presentationController else { return }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
