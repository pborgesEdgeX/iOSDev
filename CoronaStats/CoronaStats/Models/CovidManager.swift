//
//  CovidManager.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation

protocol CovidManagerDelegate {
    func DidSendData(_ covidManager: CovidManager, covid: CovidModel)
    func DidFailWithError(error: Error)
}

struct CovidManager{
    
    var delegate: CovidManagerDelegate?
    
    func getCountryData(countryID: Int, countryName: String){
        let baseURL = "https://api.covid19api.com/summary"
        performRequest(baseURL: baseURL, countryID: countryID, countryName: countryName)
    }
    
    func performRequest(baseURL: String, countryID: Int, countryName: String){
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
                    if let covid = self.parseJSON(safeData, countryID: countryID, countryNameOut: countryName){
                        self.delegate?.DidSendData(self, covid: covid)
                       }
                   }
               }
               //4. Start the task
               task.resume()
           }
       }
       
    func parseJSON(_ covidData: Data, countryID: Int, countryNameOut: String) -> CovidModel?{
          let decoder = JSONDecoder()
            do{
                var index = countryID-1
                if index < 0 {index = 0}
                let decodedData = try decoder.decode(CovidData.self, from: covidData)
                let countryName = decodedData.Countries[index].Country
                let newCases = decodedData.Countries[index].NewConfirmed
                let totalConfirmedCases = decodedData.Countries[index].TotalConfirmed
                let newDeaths = decodedData.Countries[index].NewDeaths
                let totalDeaths = decodedData.Countries[index].TotalDeaths
                let newRecovered = decodedData.Countries[index].NewRecovered
                let totalRecovered = decodedData.Countries[index].TotalRecovered
                if countryName != countryNameOut || index > decodedData.returnCountriesTotal(){
                    print("\(countryName) FAILED HEALTH CHECK")
                    return nil
                }
                let covid = CovidModel(newConfirmed: newCases, totalConfirmed: totalConfirmedCases, newDeaths: newDeaths, totalDeaths: totalDeaths, newRecovered: newRecovered, totalRecovered: totalRecovered, countryName: countryName)
                print("[\(countryName)] PASSED HEALTH CHECK")
                return covid
            } catch{
                self.delegate?.DidFailWithError(error: error)
                return nil
            }
       }

}
