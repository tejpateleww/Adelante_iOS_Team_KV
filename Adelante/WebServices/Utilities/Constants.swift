//
//  Constants.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 02/10/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

let keywindow = UIApplication.shared.keyWindow

let appDel = UIApplication.shared.delegate as! AppDelegate
let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
let AppName = AppInfo.appName
let AppURL = "itms-apps://itunes.apple.com/app/id1488928328"
let ReqDeviceType = "ios"
let Headerkey = "adelante123*#*"

let notifDeSelectFilterHome = NSNotification.Name(rawValue: "deselectFilterOptionHome")
let notifDeSelectFilterRestaurant = NSNotification.Name("deselectFilterOptionRest")
let notifRefreshDashboardList = NSNotification.Name("refreshDashboard")
let notifRefreshRestaurantList = NSNotification.Name("refreshRestaurantList")
let notifRefreshFavouriteList = NSNotification.Name("refreshFavouriteList")
let notifRefreshRestaurantDetails = NSNotification.Name("refreshRestaurantDetails")

let NotificationBadges = NSNotification.Name(rawValue:"NotificationBadges")
 
let CurrencySymbol = "$"

let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
let skeletonGradient = SkeletonGradient(baseColor: UIColor.lightGray.withAlphaComponent(0.6))
var responseStatus : webserviceResponse = .initial

enum DateFormatterString : String{
    case timeWithDate = "yyyy-MM-dd HH:mm:ss"
    case onlyDate = "yyyy-MM-dd"
}

struct ScreenSize {

    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    
    
    static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_SE         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_7PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

enum GlobalStrings : String{
    case Alert_logout = "Are you sure you want to logout ?"
    case EndSession_Logout = "Your account is logged in to another device"
}

struct selectedOrderItems{
    var restaurant_item_id : String = ""
    var quantity : String = ""
    var price : String = ""
    var variants_id : [selectedVariants] = []
    var name : String = ""
    var originalPrice : String = ""
    var size : String = ""
    var selectedQuantity : String = ""
    
    init(restaurant_item_id:String,quantity:String,price:String,variants_id:[selectedVariants],name:String,originalPrice:String,size:String, selectedQuantity:String) {
        self.restaurant_item_id = restaurant_item_id
        self.price = price
        self.quantity = quantity
        self.variants_id = variants_id
        self.name = name
        self.originalPrice = originalPrice
        self.size = size
        self.selectedQuantity = selectedQuantity
    }
}

//struct currentOrder {
//    var user_id : String = ""
//    var restaurant_id : String = ""
//    var rating : String = ""
//    var comment : String = ""
//    var sub_total : String = ""
//    var service_fee : String = ""
//    var tax : String = ""
//    var total : String = ""
//    var order : [selectedOrderItems] = []
//    var currentRestaurantDetail : RestaurantDataDetails
//    
//    init(userId:String,restautaurantId:String,rating:String,comment:String,subTotal:String,serviceFee:String,tax:String,total:String,order:[selectedOrderItems],currentRestaurantDetail:RestaurantDataDetails){
//        self.user_id = userId
//        self.restaurant_id = restautaurantId
//        self.rating = rating
//        self.comment = comment
//        self.sub_total = subTotal
//        self.service_fee = serviceFee
//        self.tax = tax
//        self.total = total
//        self.order = order
//        self.currentRestaurantDetail = currentRestaurantDetail
//    }
//}
struct selectedVariants {
    var variant_id : String = ""
    var variant_option_id : String = ""
    var variant_name : String = ""
    var variant_SubName : String = ""
    var variant_price : String = ""
    var isMultiSelect : Bool = false
    
    init(variant_id: String, variant_option_id: String, variant_name: String, variant_SubName: String, variant_price: String, isMultiSelect: Bool) {
        self.variant_id = variant_id
        self.variant_option_id = variant_option_id
        self.variant_name = variant_name
        self.variant_SubName = variant_SubName
        self.variant_price = variant_price
        self.isMultiSelect = isMultiSelect
    }
}
enum webserviceResponse {
    case gotData , initial
}
