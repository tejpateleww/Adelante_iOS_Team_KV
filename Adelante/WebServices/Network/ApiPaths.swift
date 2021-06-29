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
    case BaseURL = "http://18.208.18.170/api/User/"
    case profileBaseURL = "http://18.208.18.170/"
    static var baseURL: String{
        return APIEnvironment.environment.rawValue
    }
    
    static var environment: APIEnvironment{
        return .BaseURL
        
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
    case sendOtp = "otp_send"
    case ForgotPassword = "forgot_password"
    case changePassword = "change_password"
    case Logout = "logout"
    case GetProfile = "profile"
    case EditProfile = "profile_edit"
    case Search = "search"
    case Dashboard = "dashboard"
    case Sorting = "sorting"
    case favorite = "favorites"
    case FavoriteList = "favourite_list"
    case SettingsLink = "setting_link"
    case Feedback = "feedback"
    case RestaurantList = "restaurant"
    case RestaurantDetails = "restaurant_detail"
    case RestaurantVariants = "restaurant_variant"
    case AddCard = "add_card"
    case AddPayment = "card_list"
    case RemovePaymentList = "remove_card"
    case OrderDetails = "order_details"
    case OrderList = "order_list"
    case RateOrder = "rate_order"
    case CancelOrder = "cancel_order"
    case ShareOrder = "share_order"
    case RepeatOrder = "repeat_order"
    case Outlets = "outlet"
    case ReviewList = "review_list"
    case Notification = "notification"
    case fetch_promocode = "fetch_promocode"
    case apply_promocode = "apply_promocode"
    case order = "order"
    case Email_verify = "resend_link"
}

