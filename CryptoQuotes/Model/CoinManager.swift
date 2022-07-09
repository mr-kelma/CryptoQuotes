//
//  CoinManager.swift
//  CryptoQuotes
//
//  Created by Valery Keplin on 7.07.22.
//

import UIKit

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, coin: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "2B6F995F-A289-45AA-837D-99C61646784D"
    let coinArray = ["", "BTC", "ETH", "XRP", "ADA", "DOGE", "LTC"]
    let currencyArray = ["", "USD", "EUR", "RUB", "CNY", "CAD", "GBP", "PLN", "BRL", "AUD", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK","NZD", "RON", "SEK"]
    let imageCoin = [#imageLiteral(resourceName: "BTC"), #imageLiteral(resourceName: "ETH"), #imageLiteral(resourceName: "XRP"), #imageLiteral(resourceName: "ADA"), #imageLiteral(resourceName: "DOGE"), #imageLiteral(resourceName: "LTC")]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(coin: String, currency: String) {
        let urlString = "\(baseURL)\(coin)/\(currency)?apikey=\(apiKey)"

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", price)
                        self.delegate?.didUpdatePrice(price: priceString, coin: coin, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodeData.rate
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
