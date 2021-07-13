//
//  RestaurantDetails.swift
//  Adelante
//
//  Created by baps on 08/01/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
class RestaurantDetailsReqModel:RequestModel{
    var restaurant_id : String = ""
    var page : String = ""
    var user_id : String = ""
    var lat : String = ""
    var lng : String = ""
    var search : String = ""
}


class AddToCartReqModel:RequestModel{
    var restaurant_id : String = ""
    var item_id : String = ""
    var user_id : String = ""
    var qty : String = ""
    var addon_id : String = ""
    var search : String = ""
}


class GetCartReqModel:RequestModel{
    var user_id : String = ""
}


class UpdateCardQtyReqModel:RequestModel{
    var cart_item_id : String = ""
    var qty : String = ""
    var type : String = ""
    var search : String = ""
}

class ItemListReqModel: RequestModel{
    var user_id : String = ""
    var item_id : String = ""
}
