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
}
enum APIEnvironment : String{
    
    case bu = "http://admin.virtuwoof.com/Api/"
  
    
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

                        return ["X-API-KEY":SingletonClass.sharedInstance.Api_Key]

                    }

                }
            }
        }

    }
        return ["X-API-KEY": SingletonClass.sharedInstance.Api_Key]
    }

}
enum ApiKey: String {
    case Init                  = "User_api/init/"
    case login                 = "User_api/login"
    case ForgotPassword        = "User_api/forgot_password"
    case changePassword        = "User_api/change_password"
    case register              = "User_api/register"
    case UpdateProfile         = "User_api/profile_update"
    case Logout                = "User_api/logout/"
    
    // HOME SCREEN API
    case PadsLibraryList       = "Pads_api/pads_library_list"
    case PadsList              = "Pads_api/pads_list"
    case Order                 = "Pads_api/order"
    case CreateSong            = "Pads_api/create_song"
}

