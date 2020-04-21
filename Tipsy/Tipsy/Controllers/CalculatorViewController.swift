//
//  ViewController.swift
//  Tipsy
//
//  Created by Paulo C F Borges on 4/20/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
 
    var bill = billBrain()
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var fifteenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var splitLabel: UILabel!
    
    
    @IBAction func tipChanged(_ sender: UIButton) {
        resetAll()
        billTextField.endEditing(true)
        if !sender.isSelected{
            sender.isSelected = true
        }
        bill.calculateTip(input: sender.currentTitle ?? "0%")
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        splitLabel.text = String(format:"%.0f",sender.value)
        bill.selectNumberPeople(numberOfPeople: Int(sender.value))
    }
    
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let billValue = Float(billTextField.text!) ?? 0.0
        bill.setNewBillValue(value: billValue)
        bill.calculateTotalBill()
        self.performSegue(withIdentifier: "openResults", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openResults"{
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.billValue = bill.getTotalBill()
            destinationVC.numberOfPeople = bill.getNumberOfPeople()
            destinationVC.tip = bill.getTip()
        }
    }
    func resetAll(){
        zeroPctButton.isSelected = false
        twentyPctButton.isSelected = false
        fifteenPctButton.isSelected = false
    }
    
    
}
    
    


