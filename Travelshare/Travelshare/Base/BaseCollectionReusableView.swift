

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    class var reuseIdentifier: String {
        return String(describing: self)
    }

    class var viewSize: CGSize {
        return .zero
    }
}
