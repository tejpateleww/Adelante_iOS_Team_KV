//
//  AddToFoodlistReqModel.swift
//  Adelante
//
//  Created by iMac on 7/1/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation

class AddToFoodlistReqModel:RequestModel{
    var user_id : String = ""
    var restaurant_id : String = ""
    var item_id : String = ""
    var cart_id : String = ""
}


class GetFoodlistReqModel:RequestModel{
    var user_id : String = ""
}

class RemoveCartReqModel:RequestModel{
    var user_id : String = ""
    var cart_item_id : String = ""
    var type : String = ""
}
