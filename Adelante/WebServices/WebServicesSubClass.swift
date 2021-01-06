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
    class func ChangePassword( changepassModel : ChangePasswordReqModel,showHud : Bool = false  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = changepassModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .changePassword, httpMethod: .post, parameters: params, completion: completion)
    }
    //Forgot Password Api
    class func ForgotPassword( forgotPassword : ForgotPasswordReqModel  , showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] =  forgotPassword.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .ForgotPassword, httpMethod: .post, parameters: params, completion: completion)
    }
    
    class func UpdateProfileInfo( editProfileModel : EditProfileReqModel  ,img : UIImage ,showHud : Bool = false , completion: @escaping CompletionResponse ) {
        let  params : [String:String] = editProfileModel.generatPostParams() as! [String : String]
        WebService.shared.postDataWithImage(api: .EditProfile, showHud: false, parameter: params, image: img, imageParamName: "profile_picture", completion: completion)
    }
    class func Logout( logoutModel : LogoutReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = logoutModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .Logout, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    class func deshboard(showHud : Bool = false, completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(api: .Dashboard, parameterString: "", httpMethod: .get, showHud: false, completion: completion)
    }
    class func profile(strURL : String  ,showHud : Bool = false, completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
}


