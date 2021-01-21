//
//  RestaurantListReqModel.swift
//  Adelante
//
//  Created by baps on 08/01/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
class RestaurantListReqModel:RequestModel{
    var user_id : String = ""
    var filter : String = ""
    var item : String = ""
    var page : String = ""
    var item_id : String = ""
    var item_type : String = ""
}
