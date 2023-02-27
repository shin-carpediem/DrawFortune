import UIKit
import WebKit

//https://developer.apple.com/documentation/webkit/wkwebview
final class BrowserViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    var urlString: String = "https://google.com"
        
    // MARK: override
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        // 返り値のないメソッドをoverrideする時は、必ず親要素のメソッドを呼ぶ(でないと必須のメソッド(?がついていないメソッド)が呼ばれない)
        super.viewDidLoad()
        openUrl(urlString)
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: private
    
    private lazy var seachTextField: UITextField = {
        let view = UITextField()
        return view
    }()
    
    private func openUrl(_ string: String?) {
        guard let string = string else { return }
        let url = URL(string: string)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    private lazy var topBorder: CALayer = {
        let view = CALayer()
        view.frame = CGRect(x: 0.0, y: 100.0, width: webView.frame.size.width, height: 10.0)
        view.backgroundColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private func setupLayout() {
        webView.layer.addSublayer(topBorder) // 追加の仕方に注意
    }
}
