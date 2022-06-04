import UIKit

final class BrowserViewController: UIViewController, UITextFieldDelegate {
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: private
    


    private func setupLayout() {
        view.backgroundColor = .white

        seachTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            seachTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            seachTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            seachTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
        ])
    }
}
