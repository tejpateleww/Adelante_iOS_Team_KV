//
//  OrderReqModel.swift
//  Adelante
//
//  Created by Apple on 27/05/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
class OrderReqModel:RequestModel{
    var order_data : String = ""
}

class orderPlaceReqModel:RequestModel{
    var user_id : String = ""
    var cart_id : String = ""
    var promocode_id : String = ""
}
