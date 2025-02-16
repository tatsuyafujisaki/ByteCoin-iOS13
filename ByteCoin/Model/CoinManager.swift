import Foundation

struct CoinManager {
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
                    let bitcoinPrice = self.parseJSON(safeData)
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ data: Data) -> Double? {
        // Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            // try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)

            // Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice

        } catch {
            // Catch and print any errors.
            print(error)
            return nil
        }
    }
}
