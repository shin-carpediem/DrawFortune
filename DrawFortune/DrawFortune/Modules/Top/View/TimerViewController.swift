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
        
    private func setupLayout() {
        timerNumber.translatesAutoresizingMaskIntoConstraints = false
        HstackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerNumber)
        view.addSubview(HstackView)
        NSLayoutConstraint.activate([
            timerNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerNumber.bottomAnchor.constraint(equalTo: HstackView.topAnchor, constant: -10),
            HstackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            HstackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private lazy var timerNumber: UILabel = {
        let view = UILabel()
        return view
    }()
    
    private lazy var HstackView: UIStackView = {
        let view = UIStackView()
        return view
    }()
}