import UIKit

class MainVC: UIViewController {

    // MARK: - IBOutlets
    // -----------------
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!

    // MARK: - Main methods
    // ------------------
    func checkIfApiIsOnLine() {
        imgStatus.image = nil
        statusIndicator.startAnimating()
        let url = Routes.apiCheckOnLine
        ApiService.shared.fetchApiData(urlString: url) { (response: ResultModel?, error: ErrorModel?) in
            if let error = error {
                self.showAlertMessage(titleStr: "Error", messageStr: error.message ?? "Unknown error")
                self.imgStatus.image = #imageLiteral(resourceName: "offline")
                self.statusIndicator.stopAnimating()
                return
            }
            guard let response else {
                self.statusIndicator.stopAnimating()
                return
            }
            print("API is online: \(response.result)")
            self.imgStatus.image = response.result ? #imageLiteral(resourceName: "online") : #imageLiteral(resourceName: "offline")
            self.statusIndicator.stopAnimating()
        }
    }

    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Currencies"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        checkIfApiIsOnLine()
    }

}
