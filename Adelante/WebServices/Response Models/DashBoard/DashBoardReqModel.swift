//
//  DashBoardReqModel.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 6, 2021

import Foundation
import SwiftyJSON


class DashBoardReqModel : NSObject, NSCoding{

    var banner : [Banner]!
    var category : [Category]!
    var message : String!
    var restaurant : [Restaurant]!
    var status : Bool!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
//    init(fromJson json: JSON!){
//        if json.isEmpty{
//            return
//        }
//        banner = [Banner]()
//        let bannerArray = json["banner"].arrayValue
//        for bannerJson in bannerArray{
//            let value = Banner(fromJson: custArrayJson)
//            custArray.append(value)
//        }
//        category = [Category]()
//        let categoryArray = json["category"].arrayValue
//        for categoryJson in categoryArray{
//            let value = Category(fromJson: custArrayJson)
//            custArray.append(value)
//        }
//        message = json["message"].stringValue
//        restaurant = [Restaurant]()
//        let restaurantArray = json["restaurant"].arrayValue
//        for restaurantJson in restaurantArray{
//            let value = Restaurant(fromJson: custArrayJson)
//            custArray.append(value)
//        }
//        status = json["status"].boolValue
//    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if banner != nil{
        var dictionaryElements = [[String:Any]]()
        for bannerElement in banner {
            dictionaryElements.append(bannerElement.toDictionary())
        }
        dictionary["banner"] = dictionaryElements
        }
        if category != nil{
        var dictionaryElements = [[String:Any]]()
        for categoryElement in category {
            dictionaryElements.append(categoryElement.toDictionary())
        }
        dictionary["category"] = dictionaryElements
        }
        if message != nil{
            dictionary["message"] = message
        }
        if restaurant != nil{
        var dictionaryElements = [[String:Any]]()
        for restaurantElement in restaurant {
            dictionaryElements.append(restaurantElement.toDictionary())
        }
        dictionary["restaurant"] = dictionaryElements
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
        banner = aDecoder.decodeObject(forKey: "banner") as? [Banner]
        category = aDecoder.decodeObject(forKey: "category") as? [Category]
        message = aDecoder.decodeObject(forKey: "message") as? String
        restaurant = aDecoder.decodeObject(forKey: "restaurant") as? [Restaurant]
        status = aDecoder.decodeObject(forKey: "status") as? Bool
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if banner != nil{
            aCoder.encode(banner, forKey: "banner")
        }
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if restaurant != nil{
            aCoder.encode(restaurant, forKey: "restaurant")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }

    }

}
