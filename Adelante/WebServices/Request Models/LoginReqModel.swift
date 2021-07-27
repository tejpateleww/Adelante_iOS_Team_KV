//
//  LoginReqModel.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation

class LoginReqModel : RequestModel {
    var user_name : String = ""
    var password : String = ""
    var phone : String = ""
    var device_token : String = ""
    var device_type : String = ReqDeviceType
    var lat : String = ""
    var lng : String = ""
}
class ForgotPasswordReqModel : RequestModel
{
    var email : String = ""
}
struct UserRegistrationRequest : Encodable
{
    let FirstName, LastName, Email, Password : String

    enum CodingKeys: String, CodingKey {
        case FirstName = "First_Name"
        case LastName = "Last_Name"
        case Email, Password
    }
}
class ChangePasswordReqModel: RequestModel {
    var user_id : String = ""
    var old_password : String = ""
    var new_password : String = ""
}
class LogoutReqModel: RequestModel{
    var user_id : String = ""
}
class sendOtpReqModel: RequestModel{
    var email : String = ""
    var phone : String = ""
    var type : String = ""
}
class sendEmailVerifyReqModel: RequestModel{
    var user_name : String = ""
}
