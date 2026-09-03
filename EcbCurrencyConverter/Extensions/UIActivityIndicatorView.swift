import UIKit

extension UIActivityIndicatorView {

    func dismissLoader() {
        superview?.isUserInteractionEnabled = true
        stopAnimating()
        removeFromSuperview()
    }

}
