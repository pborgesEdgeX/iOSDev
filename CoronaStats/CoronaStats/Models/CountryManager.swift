//
//  covidManager.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation
import RealmSwift

protocol CountryManagerDelegate {
    func DidSetupArray(countryManager: CountryManager, countries: Country)
    //func DidFailWithError(error: Error)
}

struct CountryManager{
   
    var delegate: CountryManagerDelegate?
    
    func getCountryList(){
        let baseString = "https://api.covid19api.com/summary"
        let realm = try! Realm()
        let arrayTotal = realm.objects(Country.self)
        
        if arrayTotal.count != 0 {
            let now = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: (0)) as TimeZone
            let dateNow = formatter.string(from: now as Date)
            if dateNow > arrayTotal[0].date{
                do{
                    for i in arrayTotal{
                        try realm.write{
                            realm.delete(i)
                            }
                        print("Successfully deleted all elements")
                        }
                } catch{
                    print("Cannot delete all objects")
                }
            }
        }
        
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
                    //self.delegate?.DidFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let country = self.parseJSON(safeData){
                        self.delegate?.DidSetupArray(countryManager: self, countries: country)
                        print("Data saved successfully.")
                    }
                    
                }
                
//                if let safeData = data {
//                    if let country = self.parseJSON(safeData){
//                        self.delegate?.DidSetupArray(countryManager: self, countries: country)
//                    }
//                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ covidData: Data) -> Country?{
        let realm = try! Realm()
        let decoder = JSONDecoder()
        var counter = 0
        var timestamp: String = ""
        var decodedData: CovidData?
        var arrayCountry: [Country] = [Country()]
        
        
        // Retry Logic
        while counter < 100 {
            do{
                decodedData = try decoder.decode(CovidData.self, from: covidData)
                if decodedData != nil {
                    counter = 100
                }
            } catch{
                counter += 1
                print("Retrying: \(counter)")
                if counter == 100{
                    return nil
                }
            }
            
        }
        
        do{
            for (_, element) in decodedData!.Countries.enumerated(){
                    let realmCountry = Country()
                    let date = element.Date
                    timestamp = date
                    print(timestamp)
                    let countryName = element.Country
                    let slug = element.Slug
                    let newCases = element.NewConfirmed
                    let totalConfirmedCases = element.TotalConfirmed
                    let newDeaths = element.NewDeaths
                    let totalDeaths = element.TotalDeaths
                    let newRecovered = element.NewRecovered
                    let totalRecovered = element.TotalRecovered
                    
                    realmCountry.country = countryName
                    realmCountry.slug = slug
                    realmCountry.NewConfirmed = newCases
                    realmCountry.totalConfirmed = totalConfirmedCases
                    realmCountry.NewDeaths = newDeaths
                    realmCountry.totalDeaths = totalDeaths
                    realmCountry.NewRecovered = newRecovered
                    realmCountry.totalRecovered = totalRecovered
                    realmCountry.date = date
                    arrayCountry.append(realmCountry)
                    
                }
                
                do{
                    //print(arrayCountry)
                    try realm.write{
                        realm.add(arrayCountry)
                        print("Saved")
                    }
                }catch{
                    fatalError("Couldn't save the model.")
                }
                counter = 10
                return arrayCountry[0]
            
        }
        
    }
    
}
