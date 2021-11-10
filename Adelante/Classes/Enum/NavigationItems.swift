//
//  NavigationItems.swift
//  Adelante
//
//  Created by Shraddha Parmar on 30/09/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import Foundation
import Foundation
import UIKit

enum NavItemsLeft {
    case none, back ,skip
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .back:
            return "NavigationTitles_NavItemsLeft_back".Localized()
        case .skip:
            return "NavigationTitles_NavItemsLeft_skip".Localized()
        }
    }
}


enum NavItemsRight {
    case none, clearAll, saved, notifBell , liked
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .clearAll:
            return "NavigationTitles_NavItemsRight_clearAll".Localized()
        case .saved:
            return "NavigationTitles_NavItemsRight_saved".Localized()
        case .notifBell:
            return "NavigationTitles_NavItemsRight_notifBell".Localized()
        case .liked:
            return "NavigationTitles_NavItemsRight_Liked".Localized()
        }
    }
}

enum NavTitles {
    case none, myOrders, pastOrderDetails, upcomingOrderDetails,shareOrderDetails, checkout, addPayment, addCard, myAccount, myProfile, editProfile, ratingAndReviews, restaurantList, restaurantDetails, myFoodlist, termsAndConditions, privacyPolicy, aboutUs, feedback, topCategories, bffCombo, notifications, favourites , addPaymentVC , AddCardVC , bffComboVC , FeedbackVC ,checkOutVC ,BffComboVC , SearchVC ,EditLocationVC,RestaurantOutletVC,changePassword,PromocodeVC
    
    var value:String {
        switch self {
        
        case .none:
            return ""
        case .myOrders:
            return "NavigationTitles_MyOrders".Localized()
        case .pastOrderDetails:
            return "NavigationTitles_PastOrderDetails".Localized()
        case .upcomingOrderDetails:
            return "NavigationTitles_UpcomingOrderDetails".Localized()
        case .checkout:
            return "NavigationTitles_Checkout".Localized()
        case .addPayment:
            return "NavigationTitles_AddPayment".Localized()
        case .addCard:
            return "NavigationTitles_AddCard".Localized()
        case .myAccount:
            return "NavigationTitles_MyAccount".Localized()
        case .myProfile:
            return "NavigationTitles_MyProfile".Localized()
        case .editProfile:
            return "NavigationTitles_EditProfile".Localized()
        case .ratingAndReviews:
            return "NavigationTitles_Ratings&Reviews".Localized()
        case .restaurantList:
            return "NavigationTitles_RestaurantList".Localized()
        case .restaurantDetails:
            return "NavigationTitles_RestaurantDetails".Localized()
        case .myFoodlist:
            return "NavigationTitles_MyFoodlist".Localized()
        case .termsAndConditions:
            return "NavigationTitles_Terms&conditions".Localized()
        case .privacyPolicy:
            return "NavigationTitles_Privacypolicy".Localized()
        case .aboutUs:
            return "NavigationTitles_AboutUs".Localized()
        case .feedback:
            return "NavigationTitles_Feedback".Localized()
        case .topCategories:
            return "NavigationTitles_TopCategories".Localized()
        case .bffCombo:
            return "NavigationTitles_BFFCombo".Localized()
        case .notifications:
            return "NavigationTitles_Notifications".Localized()
        case .favourites:
            return "NavigationTitles_YourFavorites".Localized()
        case .addPaymentVC:
            return "NavigationTitles_AddPayment".Localized()
        case .AddCardVC:
            return "NavigationTitles_AddCard".Localized()
        case .bffComboVC:
            return "NavigationTitles_BFFCombo".Localized()
        case .FeedbackVC:
            return "NavigationTitles_Feedback".Localized()
        case .checkOutVC:
            return "NavigationTitles_Checkout".Localized()
        case .BffComboVC:
            return "NavigationTitles_BFFCombo".Localized()
        case .SearchVC:
            return "NavigationTitles_search".Localized()
        case .EditLocationVC:
            return "NavigationTitles_searchLocation".Localized()
        case .RestaurantOutletVC:
            return "NavigationTitles_RestaurantOutletVC".Localized()
        case .changePassword:
            return "NavigationTitles_ChangePasswordVC".Localized()
        case .PromocodeVC:
            return "NavigationTitles_PromoCodeVC".Localized()
        case .shareOrderDetails:
            return "NavigationTitles_ShareOrderDetails".Localized()
        }
    }
}

enum MenuItems {
    
}
