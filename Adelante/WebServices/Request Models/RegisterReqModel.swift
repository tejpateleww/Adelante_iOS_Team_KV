//
//  RegiReqModel.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
//"first_name:Divya
//last_name:Patel
//email:developer.ew.w.2@gmail.com
//password:12345678
//mobile_no:9924455780
//lat:23.644587
//lng:72.9694546
//device_type:android
//device_token:5d5vs55555555555KNKDNWD;LWJDONIKBNIBEIBF
//image : (multipart Optional)"

struct RegisterReqModel : Encodable {
    let firstName,lastName,email,mobileNumber,deviceToken,deviceType,password : String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case mobileNumber = "mobile_no"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case email,password
    }
}
