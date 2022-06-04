import UIKit
import WebKit

//https://developer.apple.com/documentation/webkit/wkwebview
final class BrowserViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var webView: WKWebView!
    var urlString: String = "https://google.com"
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.canGoBack {
            backBtn.tintColor = nil
        } else {
            backBtn.tintColor = .gray
        }
    }
    
    // MARK: override
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        createToolBarItems()
        openUrl(urlString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: private
    
    private lazy var seachTextField: UITextField = {
        let view = UITextField()
        return view
    }()
    
    private let backBtn = UIBarButtonItem(image: UIImage(named: "back"),
                                          style: .plain,
                                          target: BrowserViewController.self,
                                          action: #selector(goBack))
    
    private func setupLayout() {
        view.backgroundColor = .white
    }
    
    private func createToolBarItems() {
        toolbarItems = [
            backBtn,
            UIBarButtonItem(image: UIImage(named: "next"),
                            style: .plain,
                            target: self,
                            action: #selector(goForward)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: nil,
                            action: nil),
            UIBarButtonItem(barButtonSystemItem: .refresh,
                            target: self,
                            action: #selector(refresh))
        ]
    }
    
    private func openUrl(_ string: String?) {
        guard let string = string else { return }
        let url = URL(string: string)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @objc private func goBack() {
    }
    
    @objc private func goForward() {
    }
    
    @objc private func refresh() {
    }
}
