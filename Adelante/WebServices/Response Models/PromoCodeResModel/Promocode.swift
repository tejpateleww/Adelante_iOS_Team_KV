//
//  Promocode.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on May 25, 2021

import Foundation
import SwiftyJSON


class Promocode : NSObject, NSCoding{

    var categoryId : String!
    var descriptionField : String!
    var id : String!
    var maxAmount : String!
    var minAmount : String!
    var minLimit : String!
    var offerType : String!
    var percentage : String!
    var promocode : String!
    var useLimit : String!
    var validateDate : String!
    var subcategorytype : String!
    var applied : String!//is_apply!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        categoryId = json["category_id"].stringValue
        descriptionField = json["description"].stringValue
        id = json["id"].stringValue
        maxAmount = json["max_amount"].stringValue
        minAmount = json["min_amount"].stringValue
        minLimit = json["min_limit"].stringValue
        offerType = json["offer_type"].stringValue
        percentage = json["percentage"].stringValue
        promocode = json["promocode"].stringValue
        useLimit = json["use_limit"].stringValue
        validateDate = json["validate_date"].stringValue
        subcategorytype = json["subcategory_type"].stringValue
        applied = json["is_apply"].stringValue
    }
    
    init(FromDictonary:[String:String]){
       
        categoryId = FromDictonary["category_id"] ?? ""
        descriptionField = FromDictonary["description"] ?? ""
        id = FromDictonary["id"] ?? ""
        maxAmount = FromDictonary["max_amount"] ?? ""
        minAmount = FromDictonary["min_amount"] ?? ""
        minLimit = FromDictonary["min_limit"] ?? ""
        offerType = FromDictonary["offer_type"] ?? ""
        percentage = FromDictonary["percentage"] ?? ""
        promocode = FromDictonary["promocode"] ?? ""
        useLimit = FromDictonary["use_limit"] ?? ""
        validateDate = FromDictonary["validate_date"] ?? ""
        subcategorytype = FromDictonary["subcategory_type"] ?? ""
        applied = FromDictonary["is_apply"] ?? ""
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryId != nil{
            dictionary["category_id"] = categoryId
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if id != nil{
            dictionary["id"] = id
        }
        if maxAmount != nil{
            dictionary["max_amount"] = maxAmount
        }
        if minAmount != nil{
            dictionary["min_amount"] = minAmount
        }
        if minLimit != nil{
            dictionary["min_limit"] = minLimit
        }
        if offerType != nil{
            dictionary["offer_type"] = offerType
        }
        if percentage != nil{
            dictionary["percentage"] = percentage
        }
        if promocode != nil{
            dictionary["promocode"] = promocode
        }
        if useLimit != nil{
            dictionary["use_limit"] = useLimit
        }
        if validateDate != nil{
            dictionary["validate_date"] = validateDate
        }
        if subcategorytype != nil{
            dictionary["subcategory_type"] = subcategorytype
        }
        if applied != nil{
            dictionary["is_apply"] = applied
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        maxAmount = aDecoder.decodeObject(forKey: "max_amount") as? String
        minAmount = aDecoder.decodeObject(forKey: "min_amount") as? String
        minLimit = aDecoder.decodeObject(forKey: "min_limit") as? String
        offerType = aDecoder.decodeObject(forKey: "offer_type") as? String
        percentage = aDecoder.decodeObject(forKey: "percentage") as? String
        promocode = aDecoder.decodeObject(forKey: "promocode") as? String
        useLimit = aDecoder.decodeObject(forKey: "use_limit") as? String
        validateDate = aDecoder.decodeObject(forKey: "validate_date") as? String
        subcategorytype = aDecoder.decodeObject(forKey: "subcategory_type") as? String
        applied = aDecoder.decodeObject(forKey: "is_apply") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if maxAmount != nil{
            aCoder.encode(maxAmount, forKey: "max_amount")
        }
        if minAmount != nil{
            aCoder.encode(minAmount, forKey: "min_amount")
        }
        if minLimit != nil{
            aCoder.encode(minLimit, forKey: "min_limit")
        }
        if offerType != nil{
            aCoder.encode(offerType, forKey: "offer_type")
        }
        if percentage != nil{
            aCoder.encode(percentage, forKey: "percentage")
        }
        if promocode != nil{
            aCoder.encode(promocode, forKey: "promocode")
        }
        if useLimit != nil{
            aCoder.encode(useLimit, forKey: "use_limit")
        }
        if validateDate != nil{
            aCoder.encode(validateDate, forKey: "validate_date")
        }
        if subcategorytype != nil{
            aCoder.encode(subcategorytype, forKey: "subcategory_type")
        }
        if applied != nil{
            aCoder.encode(applied, forKey: "is_apply")
        }
    }

}
