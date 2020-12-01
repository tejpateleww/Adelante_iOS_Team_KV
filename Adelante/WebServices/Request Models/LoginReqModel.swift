//
//  LoginReqModel.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation

struct LoginReqModel : Encodable {
    
    //    let email,password,deviceToken,deviceType : String
    var email : String = ""
    var password : String = ""
    var deviceToken : String = "abc123"
    var deviceName : String? = ""
    var deviceType : String = "2"
    enum CodingKeys: String, CodingKey {
        case email,password,deviceName
        case deviceToken = "device_token"
        case deviceType = "device_type"
    }
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

class ForgotPassword : Encodable
{
    var email : String = ""
    enum CodingKeys: String, CodingKey {
        case email
    }
}

class ChangePasswordReqModel: RequestModel {
    var userId : String = ""
    var oldPassword : String = ""
    var newPassword : String = "abc123"
}

