//
//  myFoodlistDatum.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 8, 2021

import Foundation
import SwiftyJSON


class myFoodlistDatum : NSObject, NSCoding{
    var address : String!
    var cartId : String!
    var foodlistId : String!
    var grandTotal : Float!
    var id : String!
    var item : [myFoodlistItem]!
    var lat : String!
    var lng : String!
    var name : String!
    var serviceFee : String!
    var storePolicy : String!
    var tax : String!
    var total : Int!
    var totalQuantity : Int!
    var totalRound : Float!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        cartId = json["cart_id"].stringValue
        foodlistId = json["foodlist_id"].stringValue
        grandTotal = json["grand_total"].floatValue
        id = json["id"].stringValue
        item = [myFoodlistItem]()
        let itemArray = json["item"].arrayValue
        for itemJson in itemArray{
            let value = myFoodlistItem(fromJson: itemJson)
            item.append(value)
        }
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        name = json["name"].stringValue
        serviceFee = json["service_fee"].stringValue
        storePolicy = json["store_policy"].stringValue
        tax = json["tax"].stringValue
        total = json["total"].intValue
        totalQuantity = json["total_quantity"].intValue
        totalRound = json["total_round"].floatValue
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
        if cartId != nil{
            dictionary["cart_id"] = cartId
        }
        if foodlistId != nil{
            dictionary["foodlist_id"] = foodlistId
        }
        if grandTotal != nil{
            dictionary["grand_total"] = grandTotal
        }
        if id != nil{
            dictionary["id"] = id
        }
        if item != nil{
        var dictionaryElements = [[String:Any]]()
        for itemElement in item {
            dictionaryElements.append(itemElement.toDictionary())
        }
        dictionary["item"] = dictionaryElements
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        if name != nil{
            dictionary["name"] = name
        }
        if serviceFee != nil{
            dictionary["service_fee"] = serviceFee
        }
        if storePolicy != nil{
            dictionary["store_policy"] = storePolicy
        }
        if tax != nil{
            dictionary["tax"] = tax
        }
        if total != nil{
            dictionary["total"] = total
        }
        if totalQuantity != nil{
            dictionary["total_quantity"] = totalQuantity
        }
        if totalRound != nil{
            dictionary["total_round"] = totalRound
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
        cartId = aDecoder.decodeObject(forKey: "cart_id") as? String
        foodlistId = aDecoder.decodeObject(forKey: "foodlist_id") as? String
        grandTotal = aDecoder.decodeObject(forKey: "grand_total") as? Float
        id = aDecoder.decodeObject(forKey: "id") as? String
        item = aDecoder.decodeObject(forKey: "item") as? [myFoodlistItem]
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        serviceFee = aDecoder.decodeObject(forKey: "service_fee") as? String
        storePolicy = aDecoder.decodeObject(forKey: "store_policy") as? String
        tax = aDecoder.decodeObject(forKey: "tax") as? String
        total = aDecoder.decodeObject(forKey: "total") as? Int
        totalQuantity = aDecoder.decodeObject(forKey: "total_quantity") as? Int
        totalRound = aDecoder.decodeObject(forKey: "total_round") as? Float
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
        if cartId != nil{
            aCoder.encode(cartId, forKey: "cart_id")
        }
        if foodlistId != nil{
            aCoder.encode(foodlistId, forKey: "foodlist_id")
        }
        if grandTotal != nil{
            aCoder.encode(grandTotal, forKey: "grand_total")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if item != nil{
            aCoder.encode(item, forKey: "item")
        }
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if serviceFee != nil{
            aCoder.encode(serviceFee, forKey: "service_fee")
        }
        if storePolicy != nil{
            aCoder.encode(storePolicy, forKey: "store_policy")
        }
        if tax != nil{
            aCoder.encode(tax, forKey: "tax")
        }
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }
        if totalQuantity != nil{
            aCoder.encode(totalQuantity, forKey: "total_quantity")
        }
        if totalRound != nil{
            aCoder.encode(totalRound, forKey: "total_round")
        }

    }

}
