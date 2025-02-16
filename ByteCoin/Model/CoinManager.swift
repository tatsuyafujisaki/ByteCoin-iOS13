import Foundation

struct CoinManager {
    let baseURL = "https://api-realtime.exrates.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "3657346e-9b60-4825-b831-8598ef4809b2"

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]

    func getCoinPrice(for currency: String) {
        // Use String concatenation to add the selected currency at the end of the baseURL along with the API key.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        // Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            // Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)

            // Create a new data task for the URLSession
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    print(error!)
                    return
                }
                // Format the data we got back as a string to be able to print it.
                let dataAsString = String(data: data!, encoding: .utf8) ?? ""
                print(dataAsString)
            }
            // Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
}
