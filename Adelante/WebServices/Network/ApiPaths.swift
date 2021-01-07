//
//  ApiPaths.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 01/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import Alamofire
typealias NetworkRouterCompletion = ((Data?,[String:Any]?, Bool) -> ())

var userDefault = UserDefaults.standard
enum UserDefaultsKey : String {
    case userProfile = "userProfile"
    case isUserLogin = "isUserLogin"
    case X_API_KEY = "X_API_KEY"
    case DeviceToken = "DeviceToken"
    case selLanguage = "language"
    
}
enum APIEnvironment : String{
    
//    case bu = "http://adelante.excellentwebworld.in/api/User/"
//    case profileBu = "http://adelante.excellentwebworld.in/"
    case bu = "http://18.208.18.170/api/User/"
    case profileBu = "http://18.208.18.170/"
    static var baseURL: String{
        return APIEnvironment.environment.rawValue
    }
    
    static var environment: APIEnvironment{
        return .bu
        
    }
    
    static var headers : HTTPHeaders
    {

        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) != nil {

            if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == true {

                if userDefault.object(forKey:  UserDefaultsKey.userProfile.rawValue) != nil {

                    do {
                        if UserDefaults.standard.value(forKey: UserDefaultsKey.isUserLogin.rawValue) != nil,UserDefaults.standard.value(forKey:  UserDefaultsKey.isUserLogin.rawValue) as! Bool
                        {
                            let decoded  = userDefault.object(forKey: UserDefaultsKey.userProfile.rawValue ) as! Data
//                            let userdata = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! ResLoginRegisterUpdate
//                            SingletonClass.sharedInstance.Api_Key = userdata.data.apiKey

                            return ["key" : Headerkey, "X-API-KEY":SingletonClass.sharedInstance.Api_Key]

                    }

                }
            }
        }

    }
        return ["key" : Headerkey, "X-API-KEY": SingletonClass.sharedInstance.Api_Key]
    }

}
enum ApiKey: String {
    case Init = "init"
    case Register = "register"
    case login = "login"
    case ForgotPassword = "forgot_password"
    case changePassword = "change_password"
    case Logout = "logout"
    
    case Dashboard = "dashboard"
    case GetProfile = "profile"
    case EditProfile = "profile_edit"
}

