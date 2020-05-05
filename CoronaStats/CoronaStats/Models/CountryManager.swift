//
//  covidManager.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation

protocol CountryManagerDelegate {
    func DidSetupArray(countryManager: CountryManager, countries: CountryModel)
    func DidFailWithError(error: Error)
}

struct CountryManager{
    
    var delegate: CountryManagerDelegate?
    
    func getCountryList(){
        let baseString = "https://api.covid19api.com/countries"
        //let baseString = "https://api.covid19api.com/summary"
        performRequest(with: baseString)
    }

    func performRequest(with baseURL: String){
        //1. Create a URL
        if let url = URL(string: baseURL){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.DidFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let country = self.parseJSON(safeData){
                        self.delegate?.DidSetupArray(countryManager: self, countries: country)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ countryData: Data) -> CountryModel?{
         var countryArray = [""]
        do{
            let json = try JSONSerialization.jsonObject(with: countryData, options: .mutableLeaves)
            guard let data = json as? [Dictionary<String, Any>] else {return nil}
            for data: Dictionary<String, Any> in data{
                countryArray.append(data["Country"] as! String)
           }
        }
        catch{
            print(error)
        }
        
//        for (index, name) in countryArray.enumerated(){
//            if name == "Palestinian Territory"{
//                countryArray.remove(at: index)
//                print("Removed: \(name)")
//            }
//        }
        return CountryModel(country: countryArray)
    }
    
}
