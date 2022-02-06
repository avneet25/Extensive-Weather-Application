
import UIKit

extension UIView {
    func border() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 5
    }
}

extension UILabel {
    func lblDesign(color:UIColor, bgColor:UIColor) {
        self.textColor = color
        self.backgroundColor = bgColor
    }
}

extension UIView {
    func viewBorder() {
        self.layer.cornerRadius = 0.5
    }
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size.width = self.frame.width
        gradient.frame.size.height = self.frame.height
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIDevice {
var hasNotch: Bool {
    let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    return bottom > 0
}

}
