import Foundation

// By convention, Swift protocols are usually written in the file that has the class/struct which will call the
// delegate methods, i.e. the CoinManager.
protocol CoinManagerDelegate {
    // Create the method stubs wihtout implementation in the protocol.
    // It's usually a good idea to also pass along a reference to the current class.
    // e.g. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    // Check the Clima module for more info on this.
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    // Create an optional delegate that will have to implement the delegate methods.
    // Which we can notify when we have updated the price.
    var delegate: CoinManagerDelegate?

    let baseURL = "https://api-realtime.exrates.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "3657346e-9b60-4825-b831-8598ef4809b2"

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    print(error!)
                    return
                }

                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        // Optional: round the price down to 2 decimal places.
                        let priceString = String(format: "%.2f", bitcoinPrice)

                        // Call the delegate method in the delegate (ViewController) and
                        // pass along the necessary data.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
