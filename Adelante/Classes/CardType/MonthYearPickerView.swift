//
//  MonthPickerView.swift
//  Qwnched-Customer
//
//  Created by Hiral's iMac on 14/09/20.
//  Copyright © 2020 Hiral's iMac. All rights reserved.
//

import Foundation
import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months: [Int]!
    var years: [Int]!
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        var currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        if years.count == 0 {
            for _ in 1...15 {
                years.append(currentYear)
                currentYear += 1
            }
        }
        self.years = years
        currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        // population months with localized names
        var months: [Int] = []
        var month = 1
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        if self.year == currentYear {
            month = currentMonth
        }
        for _ in month...12 {
            
            //            months.append(DateFormatter().monthSymbols[month].capitalized) // for showing string
            months.append(month)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(months[row])"
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)+1
        let year = years[self.selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(month, year)
        }
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        
        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        DispatchQueue.main.async {
            if self.year == currentYear {
                var months: [Int] = []
                var cm = currentMonth
                for _ in cm...12 {
                    months.append(cm)
                    cm += 1
                }
                self.months = months
                self.reloadAllComponents()
            }
            else {
                var months: [Int] = []
                var cm = 1
                for _ in cm...12 {
                    months.append(cm)
                    cm += 1
                }
                self.months = months
                self.reloadAllComponents()
            }
        }
        self.month = month
        self.year = year
    }
}
