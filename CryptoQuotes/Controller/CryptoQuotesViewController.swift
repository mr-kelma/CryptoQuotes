//
//  ViewController.swift
//  CryptoQuotes
//
//  Created by Valery Keplin on 6.07.22.
//

import UIKit

class CryptoQuotesViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var coinLabel: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var coinPicker: UIPickerView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinPicker.tag = 1
        currencyPicker.tag = 2
        coinManager.delegate = self
        coinPicker.dataSource = self
        coinPicker.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate

extension CryptoQuotesViewController: CoinManagerDelegate {
    
    func didUpdatePrice(price: String, coin: String, currency: String) {
        DispatchQueue.main.async {
            self.coinLabel.image = UIImage(imageLiteralResourceName: coin)
            self.priceLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate

extension CryptoQuotesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return coinManager.coinArray.count
        case 2:
            return coinManager.currencyArray.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return coinManager.coinArray[row]
        case 2:
            return coinManager.currencyArray[row]
        default:
            return "error"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCoin = coinManager.coinArray[row]
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(coin: selectedCoin, currency: selectedCurrency)
    }
}
