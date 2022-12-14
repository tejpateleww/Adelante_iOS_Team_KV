//
//  Singleton.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import CoreLocation
class SingletonClass: NSObject
{
    static let sharedInstance = SingletonClass()
    
    
    var UserId : String = ""
    var LoginRegisterUpdateData : Profile?
    var Api_Key = String()
    var DeviceToken : String = ""
    var arrSorting = [Sorting]()
    var userCurrentLocation = CLLocation()
    var userDefaultLocation = CLLocation()
    var userSelectedLocation = CLLocation()
    var topSellingId : String = ""
    var isPresented = false
    var expandedCell = -1
    var selectInProcessInMyOrder : Bool?
    var selectInProcessShareOrder : Bool?
    var isShareble : Bool = false
    var arrFutureYears:[String] {
        get {
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            return (currentYear...(currentYear + 11)).map { String($0)}
        }
    }
    var IsCartHide: Bool = true
    
    func clearSingletonClass() {
        SingletonClass.sharedInstance.UserId = ""
        SingletonClass.sharedInstance.LoginRegisterUpdateData = nil
        SingletonClass.sharedInstance.Api_Key = ""
    }
}

