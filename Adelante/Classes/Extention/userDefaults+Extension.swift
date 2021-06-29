//
//  userDefaults+Extension.swift
//  Qwnched-Customer
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Hiral's iMac. All rights reserved.
//

import Foundation
extension UserDefaults{
func set<T: Codable>(object: T, forKey: String) throws {
    
    let jsonData = try JSONEncoder().encode(object)
    
    set(jsonData, forKey: forKey)
}


func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
    
    guard let result = value(forKey: forKey) as? Data else {
        return nil
    }
    
    return try JSONDecoder().decode(objectType, from: result)
}

    func setUserData(objProfile: Profile) {
    try? userDefault.set(object: objProfile, forKey: UserDefaultsKey.userProfile.rawValue)
}
    
func getUserData() -> Profile? {
    let objResponse = try? userDefault.get(objectType: Profile.self, forKey:  UserDefaultsKey.userProfile.rawValue)
    return objResponse ?? nil
}
//    func setAddressdata(){
//        try? UserDefaults.standard.set(object: SingletonClass.sharedInstance.addressInfo, forKey: UserDefaultsKey.addressInfo.rawValue)
//    }
//    func getAddressData() -> resAddressBookMain? {
//        let objResponse = try? UserDefaults.standard.get(objectType: resAddressBookMain.self, forKey:  UserDefaultsKey.addressInfo.rawValue)
//        return objResponse ?? nil
//    }
}
