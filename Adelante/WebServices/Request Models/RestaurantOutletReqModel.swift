//
//  RestaurantOutletReqModel.swift
//  Adelante
//
//  Created by baps on 09/02/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
class RestaurantOutletReqModel:RequestModel{
    var user_id : String = ""
    var filter : String = ""
    var item : String = ""
    var page : String = ""
    var restaurant_id : String = ""
    var lat : String = ""
    var lng : String = ""
}
