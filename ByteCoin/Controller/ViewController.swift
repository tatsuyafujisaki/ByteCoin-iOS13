import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!

    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Easily Missed: Must set the coinManager's delegate as this current class so that we can recieve
        // the notifications when the delegate methods are called.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

    // Provide the implementation for the delegate methods.

    // When the coinManager gets the price it will call this method and pass over the price and currency.
    func didUpdatePrice(price: String, currency: String) {
        // Remember that we need to get hold of the main thread to update the UI, otherwise our app will crash if we
        // try to do this from a background thread (URLSession works in the background).
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }

    func didFailWithError(error: any Error) {
        print(error)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
