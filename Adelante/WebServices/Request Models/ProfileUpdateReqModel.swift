//
//  ProfileUpdateReqModel.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 15/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit

struct ProfileUpdateReqModel : Encodable {
    
    let id,firstName,lastName : String
    let image = UIImage()
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        
    }
    
    ///Optional
    // var profile_picture : UIImage = UIImage()
  //  var remove_image : String = "0"
}
