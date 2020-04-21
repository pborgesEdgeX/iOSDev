//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by Paulo C F Borges on 4/20/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    var billValue: Float?
    var tip: String?
    var numberOfPeople: Int?
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = String(format: "%.2f", billValue ?? 0.00)
        settingsLabel.text = "Split between \(numberOfPeople ?? 0) people, with a \(tip ?? "0%") ) tip."
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }

}
