import UIKit
import RealityKit

final class ARViewController: UIViewController {
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private
    
    private lazy var arView: ARView = {
        let view = ARView(frame: view.bounds)
        return view
    }()
    
    private func setup() {
        view.addSubview(arView)
    }
}
