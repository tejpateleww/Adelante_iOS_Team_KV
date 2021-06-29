//
//  otpReceive.swift
//  Adelante
//
//  Created by iMac on 6/24/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import SwiftyJSON

class otpReceive : Codable{
    
    var message : String!
    var code : String!
    var status : Bool!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        message = json["message"].stringValue
        code = json["data"].stringValue
        status = json["status"].boolValue
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        status = dictionary["status"] as? Bool
        code = dictionary["data"] as? String
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if message != nil{
            dictionary["message"] = message
        }
        if code != nil{
            dictionary["data"] = code
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
        message = aDecoder.decodeObject(forKey: "message") as? String
        code = aDecoder.decodeObject(forKey: "data") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Bool
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if code != nil{
            aCoder.encode(code, forKey: "data")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        
    }
    
}
