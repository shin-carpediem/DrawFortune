import UIKit

class TopRouter: UIViewController {
    public let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .blue
        return view
    }()
    
    // 1: UIViewController → UIViewController (Embed)
    func goTimerScreen(_ view: UIView) {
        let viewController = UIViewController()
        view.window?.rootViewController = viewController
        
        let timerViewController = TimerViewController()
        viewController.addChild(timerViewController)
        viewController.view.addSubview(timerViewController.view)
        timerViewController.didMove(toParent: viewController)
    }
    
    // 2: UINavigationController → UIViewController (Root) → UIViewController (Show Detail)
    // 1のUIViewControllerで画面遷移をすると、遷移後のナビバー左にBackボタンが自動では付かないが、
    // 2のUIViewControllerを継承したUINavigationControllerだと付く。= UINavigationBarが自動生成
    func goToBrowserScreen(_ view: UIView) {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        // https://www.fuwamaki.com/article/140
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .yellow
        appearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        view.window?.rootViewController = navigationController
        showActivityIndicator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            viewController.navigationController?.pushViewController(BrowserViewController(), animated: true)
        }
    }
    
    // MARK: private
    
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
