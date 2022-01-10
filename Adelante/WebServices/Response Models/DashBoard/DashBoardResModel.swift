//
//  DashBoardResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 7, 2021

import Foundation
import SwiftyJSON


class DashBoardResModel : NSObject, NSCoding{

    var banner : [Banner]!
        var category : [Category]!
        var message : String!
        var orderIds : [String]!
        var restaurant : [Restaurant]!
        var status : Bool!
        var filterData : [FilterData]!

        /**
         * Instantiate the instance using the passed json values to set the properties values
         */
        init(fromJson json: JSON!){
            if json.isEmpty{
                return
            }
            banner = [Banner]()
            let bannerArray = json["banner"].arrayValue
            for bannerJson in bannerArray{
                let value = Banner(fromJson: bannerJson)
                banner.append(value)
            }
            category = [Category]()
            let categoryArray = json["category"].arrayValue
            for categoryJson in categoryArray{
                let value = Category(fromJson: categoryJson)
                category.append(value)
            }
            message = json["message"].stringValue
            orderIds = [String]()
            let orderIdsArray = json["order_ids"].arrayValue
            for orderIdsJson in orderIdsArray{
                orderIds.append(orderIdsJson.stringValue)
            }
            restaurant = [Restaurant]()
            let restaurantArray = json["restaurant"].arrayValue
            for restaurantJson in restaurantArray{
                let value = Restaurant(fromJson: restaurantJson)
                restaurant.append(value)
            }
            filterData = [FilterData]()
            let filterArray = json["filter_data"].arrayValue
            for filterJson in filterArray{
                let value = FilterData(fromJson: filterJson)
                filterData.append(value)
            }
            status = json["status"].boolValue
        }

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
            if orderIds != nil{
                dictionary["order_ids"] = orderIds
            }
            if restaurant != nil{
            var dictionaryElements = [[String:Any]]()
            for restaurantElement in restaurant {
                dictionaryElements.append(restaurantElement.toDictionary())
            }
            dictionary["restaurant"] = dictionaryElements
            }
            if filterData != nil{
            var dictionaryElements = [[String:Any]]()
            for filterElement in filterData {
                dictionaryElements.append(filterElement.toDictionary())
            }
            dictionary["filter_data"] = dictionaryElements
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
            orderIds = aDecoder.decodeObject(forKey: "order_ids") as? [String]
            restaurant = aDecoder.decodeObject(forKey: "restaurant") as? [Restaurant]
            filterData = aDecoder.decodeObject(forKey: "filter_data") as? [FilterData]
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
            if orderIds != nil{
                aCoder.encode(orderIds, forKey: "order_ids")
            }
            if restaurant != nil{
                aCoder.encode(restaurant, forKey: "restaurant")
            }
            if filterData != nil{
                aCoder.encode(filterData, forKey: "filter_data")
            }
            if status != nil{
                aCoder.encode(status, forKey: "status")
            }

        }

}
