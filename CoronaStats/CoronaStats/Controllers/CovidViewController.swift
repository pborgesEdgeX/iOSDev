//
//  ViewController.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import UIKit
import RealmSwift

class CovidViewController: UIViewController, CountryManagerDelegate {
    func DidSetupArray(countryManager: CountryManager, countries: Country) {
        DispatchQueue.main.async {
            print("DispatchQueue here")
            self.countryPicker.reloadAllComponents()
        }
    }
    
    
    @IBOutlet weak var dateUpdated: UILabel!
    
    var countryManager = CountryManager()
    
    let realm = try! Realm()
    var totalArray: Results<Country>?
    
    @IBOutlet weak var coutryLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    @IBOutlet weak var totalDeathLabels: UILabel!
    @IBOutlet weak var newRecoveredLabel: UILabel!
    @IBOutlet weak var totalRecoveredLabel: UILabel!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    override func viewWillAppear(_ animated: Bool) {
        countryManager.delegate = self
        countryManager.getCountryList()
        countryPicker.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCountries()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.reloadAllComponents()
        
    }
    
    func loadCountries(){
        totalArray = realm.objects(Country.self)
    }
    
    
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension CovidViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("Total number of rows: \(totalArray?.count ?? 0)")
        return totalArray?.count ?? 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let safeCountry = totalArray?[row]{
            return safeCountry.country
        } else{
            return "No Countries"
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async {
            self.coutryLabel.text = self.totalArray![row].country
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            self.newCasesLabel.text = numberFormatter.string(from: NSNumber(value: self.totalArray![row].NewConfirmed))
            self.totalCasesLabel.text = numberFormatter.string(from: NSNumber(value: self.totalArray![row].totalConfirmed))
            self.newDeathsLabel.text = numberFormatter.string(from: NSNumber(value: self.totalArray![row].NewDeaths))
            self.totalDeathLabels.text = numberFormatter.string(from: NSNumber(value: self.totalArray![row].totalDeaths))
            self.newRecoveredLabel.text = numberFormatter.string(from: NSNumber(value: self.totalArray![row].NewRecovered))
            self.totalRecoveredLabel.text = numberFormatter.string(from: NSNumber(value: self.totalArray![row].NewConfirmed))
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = formatter.date(from: self.totalArray![row].date) {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.dateUpdated.text = formatter.string(from: date)
            }
        }
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let safeCountry = totalArray?[row]{
            let attributedString = NSAttributedString(string: safeCountry.country , attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemPink])
            return attributedString
        } else{
            return NSAttributedString(string: "No Countries")
        }
        
        
    }

}


