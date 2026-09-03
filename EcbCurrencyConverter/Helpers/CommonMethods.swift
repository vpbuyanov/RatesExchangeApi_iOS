import UIKit

@MainActor
func showLoader(view: UIView) -> UIActivityIndicatorView {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    spinner.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    spinner.color = .white
    spinner.layer.cornerRadius = 3.0
    spinner.clipsToBounds = true
    spinner.hidesWhenStopped = true
    spinner.center = view.center
    view.addSubview(spinner)
    spinner.startAnimating()
    view.isUserInteractionEnabled = false
    return spinner
}
