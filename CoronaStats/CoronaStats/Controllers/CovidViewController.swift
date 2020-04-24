//
//  ViewController.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import UIKit

class CovidViewController: UIViewController {
    
    var countryManager = CountryManager()
    var covidManager = CovidManager()
    var totalCount = 0
    var totalArray:[String] = [""]
    
    @IBOutlet weak var coutryLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    @IBOutlet weak var totalDeathLabels: UILabel!
    @IBOutlet weak var newRecoveredLabel: UILabel!
    @IBOutlet weak var totalRecoveredLabel: UILabel!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryManager.delegate = self
        countryManager.getCountryList()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        covidManager.delegate = self
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension CovidViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return totalCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return totalArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        covidManager.getCountryData(countryID: row, countryName: totalArray[row])
    }
}

//MARK: - CountryManagerDelegate
extension CovidViewController:  CountryManagerDelegate{
    func DidSetupArray(countryManager: CountryManager, countries: CountryModel) {
        totalCount = countries.returnCountryTotal()
        totalArray.append(contentsOf: countries.country.sorted())
        totalArray.remove(at: 0)
        DispatchQueue.main.async {
            self.countryPicker.resignFirstResponder()
            self.countryPicker.reloadAllComponents()
        }
    }
    
    func DidFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - CovidManagerDelegate
extension CovidViewController: CovidManagerDelegate{
    func DidSendData(_ covidManager: CovidManager, covid: CovidModel) {
        DispatchQueue.main.async {
            self.coutryLabel.text = covid.countryName
            self.newCasesLabel.text = String(covid.NewConfirmed)
            self.totalCasesLabel.text = String(covid.TotalConfirmed)
            self.newDeathsLabel.text = String(covid.NewDeaths)
            self.totalDeathLabels.text = String(covid.TotalDeaths)
            self.newRecoveredLabel.text = String(covid.NewRecovered)
            self.totalRecoveredLabel.text = String(covid.TotalRecovered)
        }
    }
}


