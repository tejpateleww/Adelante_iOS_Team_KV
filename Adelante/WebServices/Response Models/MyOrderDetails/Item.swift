//
//  Item.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class Item : Codable{

    var id : String!
    var image : String!
    var mainOrderId : String!
    var price : String!
    var quantity : String!
    var restaurantItemName : String!
    var subTotal : String!
    var date : String!
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        id = json["id"].stringValue
        image = json["image"].stringValue
        mainOrderId = json["main_order_id"].stringValue
        price = json["price"].stringValue
        quantity = json["quantity"].stringValue
        restaurantItemName = json["restaurant_item_name"].stringValue
        subTotal = json["sub_total"].stringValue
        date = json["date"].stringValue
	}

}
