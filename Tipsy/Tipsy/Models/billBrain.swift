//
//  billBrain.swift
//  Tipsy
//
//  Created by Paulo C F Borges on 4/20/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation

struct billBrain {
    var bill = Bill(totalBill: 0.0, tip: 0.0, numberOfPeople: 1)
    
    mutating func calculateTip(input: String) {
        let billTip = convertPCTtoInt(value: input)
        bill.tip = billTip
    }
    
    func convertPCTtoInt(value: String) -> Float{
    switch value {
        case "0%":
            return 1
        case "15%":
            return 1.15
        case "20%":
            return 1.2
        default:
            return 1
        }
    }
    
    func convertFloattoInt(value: Float) -> String {
        switch value {
        case 1:
            return "0%"
        case 1.15:
            return "15%"
        case 1.2:
            return "20%"
        default:
            return "0%"
        }
    }
        
    mutating func selectNumberPeople(numberOfPeople: Int){
        bill.numberOfPeople = numberOfPeople
    }
    
    mutating func calculateTotalBill(){
        let newBill = ((bill.totalBill ) * bill.tip) / Float(bill.numberOfPeople )
        bill.totalBill = newBill
    }
    
    mutating func setNewBillValue(value: Float){
        bill.totalBill = value
    }
    
    func getTotalBill() -> Float{
        return bill.totalBill
    }
    
    func getNumberOfPeople() -> Int{
        return bill.numberOfPeople
    }
    
    func getTip() -> String {
        return convertFloattoInt(value: bill.tip)
        
    }
}
