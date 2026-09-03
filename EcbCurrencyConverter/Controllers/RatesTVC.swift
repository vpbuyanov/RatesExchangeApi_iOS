import UIKit

class RatesTVC: UITableViewController {

    // MARK: - Properties
    // ------------------
    private let refreshCtrl = UIRefreshControl()
    private var allRates: RatesDetailModel?
    private let cellId = "cellRate"

    // MARK: - IBOutlets
    // -----------------
    @IBOutlet weak var lblCurrenciesDate: UILabel!

    // MARK: - Main methods
    // --------------------
    @objc func fetchRatesData() {
        let spinner = showLoader(view: self.view)
        let url = Routes.latestDetailedRatesUri
        ApiService.shared.fetchApiData(urlString: url) { (rates: RatesDetailModel?, error: ErrorModel?) in
            if let error = error {
                spinner.dismissLoader()
                self.refreshCtrl.endRefreshing()
                self.showAlertMessage(titleStr: "Error", messageStr: error.message ?? "Unknown error")
                return
            }
            guard let rates else {
                spinner.dismissLoader()
                self.refreshCtrl.endRefreshing()
                return
            }
            self.allRates = rates
            self.tableView.reloadData()
            self.lblCurrenciesDate.text = "Last update date: \(rates.date)"
            self.refreshCtrl.endRefreshing()
            print("Last update date: \(rates.date)")
            spinner.dismissLoader()
        }
    }

    func setupRefreshControl() {
        tableView.refreshControl = refreshCtrl
        refreshCtrl.addTarget(self, action: #selector(fetchRatesData), for: .valueChanged)
    }

    // MARK: - Table View delegate methods
    // -----------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRates?.rates.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? RateCell else { return UITableViewCell() }
        guard let data = allRates?.rates else { return cell }
        let rateData = data[indexPath.row]
        cell.lblCurrencyDescr.text = rateData.currency
        cell.lblCurrencyIso.text = rateData.symbol
        cell.lblAmount.text = String(rateData.value)
        cell.imgCurrency.image = UIImage(named: "\(rateData.symbol.lowercased())")
        return cell
    }

    // MARK: - Segues
    // --------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConvert" {
            guard let vc = segue.destination as? CurrencyDetailsVC,
                  let indexPath = tableView.indexPathForSelectedRow,
                  let rates = allRates?.rates,
                  rates.indices.contains(indexPath.row) else { return }
            vc.rate = rates[indexPath.row]
        }
    }

    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        fetchRatesData()
        
        navigationItem.title = "ECB Rates"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
