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
    
    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
      
      class func register( registerModel : RegisterReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
              WebService.shared.requestMethod(api: .Register, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
         
      }
      class func login( loginModel : LoginReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = loginModel.generatPostParams() as! [String : String]
          
              WebService.shared.requestMethod(api: .login, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
      }
      class func ChangePassword( changepassModel : ChangePasswordReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
          let  params : [String:String] = changepassModel.generatPostParams() as! [String : String]
          WebService.shared.requestMethod(api: .changePassword, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
      }
      class func ForgotPassword( email : String ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
          let  params : [String:String] =  ["email" : email]
          WebService.shared.requestMethod(api: .ForgotPassword, httpMethod: .post, showHud: showHud,parameters: params, completion: completion)
      }
      
      class func UpdateProfileInfo( UpdateProfileReq : ProfileUpdateReqModel  ,img : UIImage ,showHud : Bool = false , completion: @escaping CompletionResponse ) {
          do {
              let requestBody = try UpdateProfileReq.asDictionary()
              WebService.shared.postDataWithImage(api: .UpdateProfile, showHud: showHud, parameter: requestBody, image: img, imageParamName: "image", completion: completion)
          } catch let error {
              debugPrint(error.localizedDescription)
          }
      }
      class func Logout( strParams : String ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
          WebService.shared.getMethod(api: .Logout, parameterString: strParams, httpMethod: .get,showHud: showHud, completion: completion)
      }
      
}


