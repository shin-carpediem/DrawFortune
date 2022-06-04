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
        super.viewDidLoad()
        openUrl(urlString)
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
}
