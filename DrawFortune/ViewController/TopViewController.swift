import UIKit

final class ViewController: UIViewController {
    // MARK: override

    // タッチでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    // MARK: private

    private let router = TopRouter()

    private let rootVStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()

    private let baseHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()

    private lazy var buttonToTimerView: UIButton = {
        let view = UIButton()
        view.setTitleColor(.green, for: .normal)
        view.setTitle("Go to Timer", for: .normal)
        view.addTarget(self, action: #selector(goTimerPage(_ :)), for: .touchUpInside)
        return view
    }()

    private lazy var rightButtonToTimerView: UIButton = {
        let view = UIButton()
        view.setTitleColor(.green, for: .normal)
        view.setTitle("Hi, Go to Browser", for: .normal)
        view.addTarget(self, action: #selector(GoBrowserPage(_ :)), for: .touchUpInside)
        return view
    }()

    private lazy var text: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.borderStyle = .roundedRect
        view.layer.borderColor = .init(genericCMYKCyan: 0.3, magenta: 0.3, yellow: 0.3, black: 0.3, alpha: 0.3)
        view.layer.borderWidth = 2
        // 自動的にキーボードを表示する
        view.becomeFirstResponder()
        view.placeholder = "Please enter your name"
        return view
    }()

    private lazy var buttonForAbove: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Send", for: .normal)
        view.addTarget(self, action: #selector(openNextPage(_ :)), for: .touchUpInside)
        return view
    }()

    private let circle: PaddingLabel = {
        let view = PaddingLabel()
        view.padding = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
        view.frame.size.width = 200
        view.frame.size.height = 200
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = 100
        view.textAlignment = .center
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
        view.addTarget(self, action: #selector(getFortune(_ :)), for: .touchUpInside)
        return view
    }()

    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(router.activityIndicator)
        view.addSubview(rootVStack)

        view.translatesAutoresizingMaskIntoConstraints = false
        router.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        rootVStack.translatesAutoresizingMaskIntoConstraints = false
        baseHStack.translatesAutoresizingMaskIntoConstraints = false
        buttonToTimerView.translatesAutoresizingMaskIntoConstraints = false
        rightButtonToTimerView.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        buttonForAbove.translatesAutoresizingMaskIntoConstraints = false
        circle.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        rootVStack.addArrangedSubview(baseHStack)
        rootVStack.addArrangedSubview(text)
        rootVStack.addArrangedSubview(buttonForAbove)
        rootVStack.addArrangedSubview(circle)
        rootVStack.addArrangedSubview(button)

        baseHStack.addArrangedSubview(buttonToTimerView)
        baseHStack.addArrangedSubview(rightButtonToTimerView)

        NSLayoutConstraint.activate([
            router.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            router.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            rootVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootVStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rootVStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rootVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            baseHStack.bottomAnchor.constraint(equalTo: text.topAnchor, constant: -100),

            circle.widthAnchor.constraint(equalToConstant: 200),
            circle.heightAnchor.constraint(equalToConstant: 200),

            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 100),
            button.bottomAnchor.constraint(equalTo: rootVStack.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func notifyKeyboardAction() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWIllShow(sender: )),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWIllHide(sender: )),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }

    @objc private func goTimerPage(_ sender: UIButton) {
        router.goTimerScreen(view)
    }

    @objc private func GoBrowserPage(_ sender: UIButton) {
        router.goToBrowserScreen(view)
    }

    // UIViewController → UIViewController (Present Modally)
    @objc private func openNextPage(_ sender: UIButton) {
        guard let inputText = text.text else { return }
        if (inputText == "") {
            let alertController = UIAlertController(title: "名前入力欄が空です", message: "名前を1文字以上入力してください", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        } else {
            let nameJudgeViewController = NameJudgeViewController(inputText)
            // iOS 13以降、Modalの場合、遷移先のViewDidAppearが呼ばれないので、遷移元・先でdelegateを指定する
            // https://zenn.dev/tanukidevelop/articles/4d72e467c77241
            nameJudgeViewController.presentationController?.delegate = self
            present(nameJudgeViewController, animated: true)
        }
    }

    @objc private func getFortune(_ sender: UIButton) {
        let fortune = ["大吉", "吉", "中吉", "凶"]
        let random = Int.random(in: 1...fortune.count)
        circle.text = fortune[Int(random) - 1]
    }

    // キーボードが表示された時
    @objc private func keyboardWIllShow(sender: NSNotification) {
        if text.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -150)
                self.view.transform = transform
            })
        }
    }

    // キーボードが閉じられた時
    @objc private func keyboardWIllHide(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
        UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
            self.view.transform = CGAffineTransform.identity
        })
    }
}

// MARK: extension

// Modalを閉じる時のイベントを取得する
extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        text.text = ""
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int = 10
        let strings = textField.text! + string
        if strings.count <= maxLength {
            return true
        } else {
            return false
        }
    }

    func textFieldShouldReturn(_ text: UITextField) -> Bool {
        text.resignFirstResponder()
        return true
    }
}
