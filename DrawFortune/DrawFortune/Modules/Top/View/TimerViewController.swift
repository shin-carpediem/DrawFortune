import UIKit

final class TimerViewController: UIViewController {
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: private
    
    private let timerNumber: UILabel = {
        let view = UILabel()
        let string = NSMutableAttributedString()
        string.append(NSMutableAttributedString(
            string: "00:00:00",
            attributes: [.font: UIFont.systemFont(ofSize: 24)]
        ))
        view.attributedText = string
        return view
    }()
    
    private let HstackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    private let startButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Start", for: .normal)
        return view
    }()
    
    private let stopButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Stop", for: .normal)
        return view
    }()
    
    private let resetButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Reset", for: .normal)
        return view
    }()
        
    private func setupLayout() {
        view.backgroundColor = .white
        
        timerNumber.translatesAutoresizingMaskIntoConstraints = false
        HstackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(timerNumber)
        view.addSubview(HstackView)
        HstackView.addArrangedSubview(startButton)
        HstackView.addArrangedSubview(stopButton)
        HstackView.addArrangedSubview(resetButton)

        NSLayoutConstraint.activate([
            timerNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerNumber.bottomAnchor.constraint(equalTo: HstackView.topAnchor, constant: -10),

            HstackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            HstackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            HstackView.topAnchor.constraint(equalTo: timerNumber.bottomAnchor),
            HstackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            HstackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            HstackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
