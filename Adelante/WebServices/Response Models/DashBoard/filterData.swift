//
//  filterData.swift
//  Adelante
//
//  Created by Harsh Dave on 10/01/22.
//  Copyright © 2022 EWW071. All rights reserved.
//

import Foundation
import SwiftyJSON

class FilterData : NSObject, NSCoding{

    var id : String!
    var name : String!
    var value : String!
    var displayorder : String!//display_order
    var trash : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        name = json["name"].stringValue
        value = json["value"].stringValue
        displayorder = json["display_order"].stringValue
        trash = json["trash"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if value != nil{
            dictionary["value"] = value
        }
        if trash != nil{
            dictionary["trash"] = trash
        }
        if displayorder != nil{
            dictionary["display_order"] = displayorder
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        value = aDecoder.decodeObject(forKey: "value") as? String
        trash = aDecoder.decodeObject(forKey: "trash") as? String
        displayorder = aDecoder.decodeObject(forKey: "display_order") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if value != nil{
            aCoder.encode(value, forKey: "value")
        }
        if trash != nil{
            aCoder.encode(trash, forKey: "trash")
        }
        if displayorder != nil{
            aCoder.encode(displayorder, forKey: "display_order")
        }
    }

}
