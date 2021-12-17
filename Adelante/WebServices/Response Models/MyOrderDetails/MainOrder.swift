//
//  MainOrder.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on October 13, 2021

import Foundation
import SwiftyJSON


class MainOrder : Codable{

    var address : String!
    var createdAt : String!
    var discount : String!
    var discountAmount : String!
    var isRate : String!
    var isShare : String!
    var isCancel : String!
    var item : [Item]!
    var itemQuantity : String!
    var orderId : String!
    var promocode : String!
    var promocodeId : String!
    var promocodeType : String!
    var qrcode : String!
    var restaurantId : String!
    var restaurantName : String!
    var serviceFee : String!
    var shareFrom : String!
    var shareOrder : String!
    var shareOrderId : String!
    var shareTo : String!
    var street : String!
    var subTotal : String!
    var tax : String!
    var total : String!
    var totalRound : String!
    var trash : String!
    var username : String!
    var status : String!
    var deliveryType: String!
    var parking_no: String!
    var parking_type: String!
    var parking_id: String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        createdAt = json["created_at"].stringValue
        discount = json["discount"].stringValue
        discountAmount = json["discount_amount"].stringValue
        isRate = json["is_rate"].stringValue
        isShare = json["is_share"].stringValue
        isCancel = json["is_cancel"].stringValue
        item = [Item]()
        let itemArray = json["item"].arrayValue
        for itemJson in itemArray{
            let value = Item(fromJson: itemJson)
            item.append(value)
        }
        itemQuantity = json["item_quantity"].stringValue
        orderId = json["order_id"].stringValue
        promocode = json["promocode"].stringValue
        promocodeId = json["promocode_id"].stringValue
        promocodeType = json["promocode_type"].stringValue
        qrcode = json["qrcode"].stringValue
        restaurantId = json["restaurant_id"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        serviceFee = json["service_fee"].stringValue
        shareFrom = json["share_from"].stringValue
        shareOrder = json["share_order"].stringValue
        shareOrderId = json["share_order_id"].stringValue
        shareTo = json["share_to"].stringValue
        street = json["street"].stringValue
        subTotal = json["sub_total"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].stringValue
        totalRound = json["total_round"].stringValue
        trash = json["trash"].stringValue
        username = json["username"].stringValue
        status = json["status"].stringValue
        deliveryType = json["delivery_type"].stringValue
        parking_no = json["parking_no"].stringValue
        parking_type = json["parking_type"].stringValue
        parking_id = json["parking_id"].stringValue
    }

}
