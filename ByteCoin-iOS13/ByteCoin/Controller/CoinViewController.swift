//
//  ViewController.swift
//  ByteCoin
//
//  Created by Paulo Borges.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {

    var coinManager = CoinManager()
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension CoinViewController: UIPickerViewDataSource,  UIPickerViewDelegate{
    
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
           coinManager.fetchCoinData(desiredCurrency: coinManager.currencyArray[row])
       }
}

//MARK: - CoinManagerDelegate
extension CoinViewController: CoinManagerDelegate{
    
    func DidUpdateCoin(coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", coin.rate)
            self.currencyLabel.text = coin.baseCoin
        }
    }
    
    func DidFailWithError(error: Error) {
        print(error)
    }
}
