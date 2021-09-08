//
//  Datum.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on August 19, 2021

import Foundation
import SwiftyJSON


class orderListingData : NSObject, NSCoding{

    var address : String!
    var createdAt : String!
    var date : String!
    var id : String!
    var image : String!
    var isCancel : String!
    var isShare : String!
    var lat : String!
    var lng : String!
    var price : String!
    var restaurantId : String!
    var restaurantItemName : String!
    var restaurantName : String!
    var shareOrderId : String!
    var status : String!
    var street : String!
    var total : String!
    var username : String!
    var trash : String!

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
        isShare = json["is_share"].stringValue
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        price = json["price"].stringValue
        restaurantId = json["restaurant_id"].stringValue
        restaurantItemName = json["restaurant_item_name"].stringValue
        restaurantName = json["restaurant_name"].stringValue
        shareOrderId = json["share_order_id"].stringValue
        status = json["status"].stringValue
        street = json["street"].stringValue
        total = json["total"].stringValue
        username = json["username"].stringValue
        trash = json["trash"].stringValue
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
        if isShare != nil{
            dictionary["is_share"] = isShare
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        if price != nil{
            dictionary["price"] = price
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
        if shareOrderId != nil{
            dictionary["share_order_id"] = shareOrderId
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
        if username != nil{
            dictionary["username"] = username
        }
        if trash != nil{
            dictionary["trash"] = trash
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
        isShare = aDecoder.decodeObject(forKey: "is_share") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        restaurantId = aDecoder.decodeObject(forKey: "restaurant_id") as? String
        restaurantItemName = aDecoder.decodeObject(forKey: "restaurant_item_name") as? String
        restaurantName = aDecoder.decodeObject(forKey: "restaurant_name") as? String
        shareOrderId = aDecoder.decodeObject(forKey: "share_order_id") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        street = aDecoder.decodeObject(forKey: "street") as? String
        total = aDecoder.decodeObject(forKey: "total") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        trash = aDecoder.decodeObject(forKey: "trash") as! String
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
        if isShare != nil{
            aCoder.encode(isShare, forKey: "is_share")
        }
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
        if price != nil{
            aCoder.encode(price, forKey: "price")
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
        if shareOrderId != nil{
            aCoder.encode(shareOrderId, forKey: "share_order_id")
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
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        if trash != nil{
            aCoder.encode(trash, forKey: "trash")
        }
    }

}
