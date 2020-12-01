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
    case none, back
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .back:
            return "back"
        }
    }
}


enum NavItemsRight {
    case none, clearAll, saved
    
    var value:String {
        switch self {
        case .none:
            return ""
        case .clearAll:
            return "clearAll"
        case .saved:
            return "saved"
        }
    }
}

enum NavTitles {
    case none, myOrders, pastOrderDetails, upcomingOrderDetails, checkout, addPayment, addCard, myAccount, myProfile, editProfile, ratingAndReviews, restaurantList, restaurantDetails, myFoodlist, termsAndConditions, privacyPolicy, aboutUs, feedback, topCategories, bffCombo, notifications, favourites
    
    var value:String {
        switch self {
            
        case .none:
            return ""
        case .myOrders:
            return "My Orders"
        case .pastOrderDetails:
            return "Past Order Details"
        case .upcomingOrderDetails:
            return "Upcoming Order Details"
        case .checkout:
            return "Checkout"
        case .addPayment:
            return "Add Payment"
        case .addCard:
            return "Add Card"
        case .myAccount:
            return "My Account"
        case .myProfile:
            return "My Profile"
        case .editProfile:
            return "Edit Profile"
        case .ratingAndReviews:
            return "Ratings & Reviews"
        case .restaurantList:
            return "Restaurant List"
        case .restaurantDetails:
            return "Restaurant Details"
        case .myFoodlist:
            return "My Foodlist"
        case .termsAndConditions:
            return "Terms & conditions"
        case .privacyPolicy:
            return "Privacy policy"
        case .aboutUs:
            return "About Us"
        case .feedback:
            return "Feedback"
        case .topCategories:
            return "Top Categories"
        case .bffCombo:
            return "BFF Combo"
        case .notifications:
            return "Notifications"
        case .favourites:
            return "Your Favourites"
        }
    }
}
