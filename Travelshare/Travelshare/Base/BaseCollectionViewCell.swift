
import UIKit
import SnapKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var needAddCommonBackground: Bool = false
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }

    open class var cellSize: CGSize {
        return .zero
    }

    var ignoreClickEffect: Bool = false

    override var isHighlighted: Bool {
        didSet {
            if ignoreClickEffect {
                contentView.transform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
    }
    
    func fillData(_ data: Any?) {
    }
}
