//
//  RestaurantVariantResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 1, 2021

import Foundation
import SwiftyJSON

class RestaurantVariantResModel : NSObject, NSCoding{

    var variants : [Variant]!
    var itemPrice : String!
    var message : String!
    var status : Bool!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        variants = [Variant]()
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = Variant(fromJson: dataJson)
            variants.append(value)
        }
        itemPrice = json["item_price"].stringValue
        message = json["message"].stringValue
        status = json["status"].boolValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if variants != nil{
        var dictionaryElements = [[String:Any]]()
        for dataElement in variants {
            dictionaryElements.append(dataElement.toDictionary())
        }
        dictionary["data"] = dictionaryElements
        }
        if itemPrice != nil{
            dictionary["item_price"] = itemPrice
        }
        if message != nil{
            dictionary["message"] = message
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        variants = aDecoder.decodeObject(forKey: "data") as? [Variant]
        itemPrice = aDecoder.decodeObject(forKey: "item_price") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Bool
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if variants != nil{
            aCoder.encode(variants, forKey: "data")
        }
        if itemPrice != nil{
            aCoder.encode(itemPrice, forKey: "item_price")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }

    }

}
