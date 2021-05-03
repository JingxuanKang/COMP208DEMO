

import UIKit

private let NotchSize = CGSize(width: 375, height: 812)
private let NoNotchSize = CGSize(width: 375, height: 667)
private let PadSize = CGSize(width: 768, height: 1024)

/**
notch: 有刘海的手机
noNoth: 无刘海的手机
*/

private let ViewSize = UIScreen.main.bounds.size

func formatX(_ notch: CGFloat, _ noNotch: CGFloat = .greatestFiniteMagnitude, pad: CGFloat = .greatestFiniteMagnitude, padScale: CGFloat = 1.3) -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return floor((pad == .greatestFiniteMagnitude ? notch : pad) * ( ViewSize.width / PadSize.width) * padScale)
    }
    if UIDevice.hasNotch || noNotch == .greatestFiniteMagnitude {
        return floor(notch * (ViewSize.width / NotchSize.width))
    } else {
        return floor(noNotch * (ViewSize.width / NoNotchSize.width))
    }
}

func formatY(_ notch: CGFloat, _ noNotch: CGFloat = .greatestFiniteMagnitude, pad: CGFloat = .greatestFiniteMagnitude, padScale: CGFloat = 1.3) -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return floor((pad == .greatestFiniteMagnitude ? notch : pad) * ( ViewSize.height / PadSize.height) * padScale)
    }
    if UIDevice.hasNotch || noNotch == .greatestFiniteMagnitude {
        return floor(notch * (ViewSize.height / NotchSize.height))
    } else {
        return floor(noNotch * (ViewSize.height / NoNotchSize.height))
    }
}

extension UIDevice {
    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    class var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    class var statusBarHeight: CGFloat {
        if let top = UIApplication.shared.keyWindow?.safeAreaInsets.top, top > 0 {
            return top
        }
        return 20
    }
    class var topNotchHeight: CGFloat {
        if let size = UIApplication.shared.keyWindow?.safeAreaInsets.top, size > 0 {
            return size
        }
        return 0
    }
    class var bottomNotchHeight: CGFloat {
        if let size = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, size > 0 {
            return size
        }
        return 0
    }
    
    class var tabbarHeight: CGFloat {
        return 49
    }
}

extension UIScreen {
    class var width: CGFloat {
        return ViewSize.width
    }
    class var height: CGFloat {
        return ViewSize.height
    }
}


let hLineSpacing: CGFloat = 16.0
let appNormalMainColor: UIColor = .init(hex: 0x999999)
let appMainColor: UIColor = .init(hex: 0x007aff)
