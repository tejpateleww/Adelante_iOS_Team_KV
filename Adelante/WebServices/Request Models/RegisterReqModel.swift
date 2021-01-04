//
//  RegiReqModel.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
class RegisterReqModel : RequestModel {
    var first_name : String = ""
    var last_name : String = ""
    var user_name : String = ""
    var phone : String = ""
    var password : String = ""
    var device_token : String = ""
    var device_type : String = ReqDeviceType
    var lat : String  = ""
    var lng : String  = ""
}
