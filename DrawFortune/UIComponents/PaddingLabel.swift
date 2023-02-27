import UIKit

public class PaddingLabel: UILabel {
    public var padding: UIEdgeInsets = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
