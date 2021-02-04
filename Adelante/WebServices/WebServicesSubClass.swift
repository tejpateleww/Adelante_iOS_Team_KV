//
//  WebServicesSubClass.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 01/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit
class WebServiceSubClass
{
    //init Api
    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
    //Register Api
    class func register( registerModel : RegisterReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .Register, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    //Login Api
    class func login( loginModel : LoginReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = loginModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .login, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    class func Settings( showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(api: .SettingsLink, parameterString: "", httpMethod: .get, showHud: false, completion: completion)
    }
    //Change Password
    class func ChangePassword( changepassModel : ChangePasswordReqModel,showHud : Bool = false  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = changepassModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .changePassword, httpMethod: .post, parameters: params, completion: completion)
    }
    //Forgot Password Api
    class func ForgotPassword( forgotPassword : ForgotPasswordReqModel  , showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] =  forgotPassword.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .ForgotPassword, httpMethod: .post, parameters: params, completion: completion)
    }
    //Update Profile
    class func UpdateProfileInfo( editProfileModel : EditProfileReqModel  ,img : UIImage,isRemoveImage: Bool ,showHud : Bool = false , completion: @escaping CompletionResponse ) {
        let  params : [String:String] = editProfileModel.generatPostParams() as! [String : String]
        WebService.shared.postDataWithImage(api: .EditProfile, isRemoveimage: isRemoveImage, showHud: false, parameter: params, image: img, imageParamName: "profile_picture", completion: completion)
    }
    //Logout
    class func Logout( logoutModel : LogoutReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = logoutModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .Logout, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    class func deshboard( DashboardModel : DashboardReqModel ,showHud : Bool = false, completion: @escaping CompletionResponse ) {
        let params : [String:String] = DashboardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Dashboard, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    //Profile
    class func profile(strURL : String  ,showHud : Bool = false, completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
    //sorting
    class func sorting(showHud : Bool = false, completion: @escaping CompletionResponse ){
//        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
        WebService.shared.getMethod(api: .Sorting, parameterString: "", httpMethod: .get, showHud: false, completion: completion)
    }
    class func search( Searchmodel : SearchReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Searchmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Search, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func RestaurantFavorite( RestaurantFavoritemodel : RestaurantFavoriteReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = RestaurantFavoritemodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .FavoriteList, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func Favorite( Favoritemodel : FavoriteReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Favoritemodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .favorite, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func RestaurantList( RestaurantListmodel : RestaurantListReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = RestaurantListmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RestaurantList, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func RestaurantDetails( RestaurantDetailsmodel : RestaurantDetailsReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = RestaurantDetailsmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RestaurantDetails, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func RestaurantVariants( RestaurantVariantsmodel : RestaurantVariantsReqModel,showHud : Bool = false , completion : @escaping CompletionResponse ){
        let params : [String:String] = RestaurantVariantsmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RestaurantVariants, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func Feedback( Feedbackmodel : FeedbackReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Feedbackmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Feedback, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func addCard( addcardsmodel : AddCardReqModel,showHud : Bool = false , completion : @escaping CompletionResponse ){
        let params : [String:String] = addcardsmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddCard, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
    class func addPayment( addpaymentmodel : AddPaymentReqModel,showHud : Bool = false , completion : @escaping CompletionResponse ){
        let params : [String:String] = addpaymentmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddPayment, httpMethod: .post, showHud: false, parameters: params, completion: completion)
    }
}


