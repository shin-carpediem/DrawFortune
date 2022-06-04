import UIKit

final class TimerViewController: UIViewController {
        
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setButtonEnabled(start: true, stop: false, reset: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: private
    
    private var startTime: TimeInterval? = nil // Double
    private var timer = Timer()
    private var elapsedTime: Double = 0.0
        
    private func setButtonEnabled(start: Bool, stop: Bool, reset: Bool) {
        startButton.isEnabled = start
        stopButton.isEnabled = stop
        resetButton.isEnabled = reset
    }
    
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
    
    private lazy var startButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Start", for: .normal)
        view.addTarget(self, action: #selector(startAction(sender:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var stopButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Stop", for: .normal)
        view.addTarget(self, action: #selector(stopAction(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var resetButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.blue, for: .normal)
        view.setTitle("Reset", for: .normal)
        view.addTarget(self, action: #selector(resetAction(_:)), for: .touchUpInside)
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
            HstackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func update() {
        if let startTime = self.startTime {
            let passedTime: Double = Date.timeIntervalSinceReferenceDate - startTime + self.elapsedTime
            let minute = Int(passedTime / 60)
            let second = Int(passedTime) % 60
            let milisecond = Int((passedTime - Double(minute * 60) - Double(second)) * 100.0)
            // %02d は、余白を0で埋め(=0)、最大2桁で表示し(=2)、10進数で表現(=d)
            // なお16進数はx
            timerNumber.text = String(format: "%02d:%02d:%02d", minute, second, milisecond)
        }
    }
    
    @objc private func startAction(sender: UIButton) {
        setButtonEnabled(start: false, stop: true, reset: false)
        startTime = Date.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                             target: self,
                             selector: #selector(update),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func stopAction(_ sender: UIButton) {
        setButtonEnabled(start: true, stop: false, reset: true)
        if let startTime = self.startTime {
            elapsedTime += Date.timeIntervalSinceReferenceDate - startTime
        }
        timer.invalidate()
    }
    
    @objc private func resetAction(_ sender: UIButton) {
        setButtonEnabled(start: true, stop: false, reset: false)
        startTime = nil
        timerNumber.text = "00:00:00"
        elapsedTime = 0.0
    }
}
