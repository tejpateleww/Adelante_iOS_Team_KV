//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on August 19, 2021

import Foundation
import SwiftyJSON
//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on November 11, 2021

import Foundation
import SwiftyJSON


class orderListingData : NSObject, NSCoding{

    var address : String!
    var createdAt : String!
    var date : String!
    var id : String!
    var image : String!
    var isCancel : String!
    var isRate : String!
    var isRepeat : String!
    var isShare : String!
    var lat : String!
    var lng : String!
    var paymentStatus : String!
    var price : String!
    var promocode : String!
    var promocodeId : String!
    var promocodePercentage : String!
    var promocodeType : String!
    var restaurantId : String!
    var restaurantItemName : String!
    var restaurantName : String!
    var shareFrom : String!
    var shareOrderId : String!
    var shareTo : String!
    var status : String!
    var street : String!
    var total : String!
    var trash : String!
    var userId : String!
    var username : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        createdAt = json["created_at"].stringValue
        date = json["date"].stringValue
        id = json["id"].stringValue
        image = json["image"].stringValue
        isCancel = json["is_cancel"].stringValue
        isRate = json["is_rate"].stringValue
        isRepeat = json["is_repeat"].stringValue
        isShare = json["is_share"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        paymentStatus = json["payment_status"].stringValue
        price = json["price"].stringValue
        promocode = json["promocode"].stringValue
        promocodeId = json["promocode_id"].stringValue
        promocodePercentage = json["promocode_percentage"].stringValue
        promocodeType = json["promocode_type"].stringValue
        restaurantId = json["restaurant_id"].stringValue
        restaurantItemName = json["restaurant_item_name"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        shareFrom = json["share_from"].stringValue
        shareOrderId = json["share_order_id"].stringValue
        shareTo = json["share_to"].stringValue
        status = json["status"].stringValue
        street = json["street"].stringValue
        total = json["total"].stringValue
        trash = json["trash"].stringValue
        userId = json["user_id"].stringValue
        username = json["username"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if date != nil{
            dictionary["date"] = date
        }
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if isCancel != nil{
            dictionary["is_cancel"] = isCancel
        }
        if isRate != nil{
            dictionary["is_rate"] = isRate
        }
        if isRepeat != nil{
            dictionary["is_repeat"] = isRepeat
        }
        if isShare != nil{
            dictionary["is_share"] = isShare
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        if paymentStatus != nil{
            dictionary["payment_status"] = paymentStatus
        }
        if price != nil{
            dictionary["price"] = price
        }
        if promocode != nil{
            dictionary["promocode"] = promocode
        }
        if promocodeId != nil{
            dictionary["promocode_id"] = promocodeId
        }
        if promocodePercentage != nil{
            dictionary["promocode_percentage"] = promocodePercentage
        }
        if promocodeType != nil{
            dictionary["promocode_type"] = promocodeType
        }
        if restaurantId != nil{
            dictionary["restaurant_id"] = restaurantId
        }
        if restaurantItemName != nil{
            dictionary["restaurant_item_name"] = restaurantItemName
        }
        if restaurantName != nil{
            dictionary["restaurant_name"] = restaurantName
        }
        if shareFrom != nil{
            dictionary["share_from"] = shareFrom
        }
        if shareOrderId != nil{
            dictionary["share_order_id"] = shareOrderId
        }
        if shareTo != nil{
            dictionary["share_to"] = shareTo
        }
        if status != nil{
            dictionary["status"] = status
        }
        if street != nil{
            dictionary["street"] = street
        }
        if total != nil{
            dictionary["total"] = total
        }
        if trash != nil{
            dictionary["trash"] = trash
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if username != nil{
            dictionary["username"] = username
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        isCancel = aDecoder.decodeObject(forKey: "is_cancel") as? String
        isRate = aDecoder.decodeObject(forKey: "is_rate") as? String
        isRepeat = aDecoder.decodeObject(forKey: "is_repeat") as? String
        isShare = aDecoder.decodeObject(forKey: "is_share") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        paymentStatus = aDecoder.decodeObject(forKey: "payment_status") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        promocode = aDecoder.decodeObject(forKey: "promocode") as? String
        promocodeId = aDecoder.decodeObject(forKey: "promocode_id") as? String
        promocodePercentage = aDecoder.decodeObject(forKey: "promocode_percentage") as? String
        promocodeType = aDecoder.decodeObject(forKey: "promocode_type") as? String
        restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
        restaurantItemName = aDecoder.decodeObject(forKey: "restaurant_item_name") as? String
        restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
        shareFrom = aDecoder.decodeObject(forKey: "share_from") as? String
        shareOrderId = aDecoder.decodeObject(forKey: "share_order_id") as? String
        shareTo = aDecoder.decodeObject(forKey: "share_to") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        street = aDecoder.decodeObject(forKey: "street") as? String
        total = aDecoder.decodeObject(forKey: "total") as? String
        trash = aDecoder.decodeObject(forKey: "trash") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if isCancel != nil{
            aCoder.encode(isCancel, forKey: "is_cancel")
        }
        if isRate != nil{
            aCoder.encode(isRate, forKey: "is_rate")
        }
        if isRepeat != nil{
            aCoder.encode(isRepeat, forKey: "is_repeat")
        }
        if isShare != nil{
            aCoder.encode(isShare, forKey: "is_share")
        }
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
        if paymentStatus != nil{
            aCoder.encode(paymentStatus, forKey: "payment_status")
        }
        if price != nil{
            aCoder.encode(price, forKey: "price")
        }
        if promocode != nil{
            aCoder.encode(promocode, forKey: "promocode")
        }
        if promocodeId != nil{
            aCoder.encode(promocodeId, forKey: "promocode_id")
        }
        if promocodePercentage != nil{
            aCoder.encode(promocodePercentage, forKey: "promocode_percentage")
        }
        if promocodeType != nil{
            aCoder.encode(promocodeType, forKey: "promocode_type")
        }
        if restaurantId != nil{
            aCoder.encode(restaurantId, forKey: "restaurant_id")
        }
        if restaurantItemName != nil{
            aCoder.encode(restaurantItemName, forKey: "restaurant_item_name")
        }
        if restaurantName != nil{
            aCoder.encode(restaurantName, forKey: "restaurant_name")
        }
        if shareFrom != nil{
            aCoder.encode(shareFrom, forKey: "share_from")
        }
        if shareOrderId != nil{
            aCoder.encode(shareOrderId, forKey: "share_order_id")
        }
        if shareTo != nil{
            aCoder.encode(shareTo, forKey: "share_to")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if street != nil{
            aCoder.encode(street, forKey: "street")
        }
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }
        if trash != nil{
            aCoder.encode(trash, forKey: "trash")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }

    }

}
