//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Paulo Borges.
//  Copyright © 2020. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func DidUpdateCoin(coinManager: CoinManager, coin: CoinModel)
    func DidFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "F1056538-C435-4998-BE1E-16E92975CD7A"
    
    func fetchCoinData(desiredCurrency: String){
        performRequest(baseString: desiredCurrency, apiKey: apiKey)
    }
    
    func performRequest(baseString: String, apiKey: String){
        //1. Create a URL
        let baseString = "\(baseURL)BTC/\(baseString)?apikey=\(apiKey)"
        if let url = URL(string: baseString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.DidFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData){
                        self.delegate?.DidUpdateCoin(coinManager: self, coin: coin)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let baseCoin = decodedData.asset_id_quote
            let rate = decodedData.rate
            let coin = CoinModel(baseCoin: baseCoin, rate: rate)
            return coin
            
        } catch{
            //self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    

}
