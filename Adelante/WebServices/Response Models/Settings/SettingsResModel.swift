//
//  SettingsResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 18, 2021

import Foundation
import SwiftyJSON


class SettingsResModel : NSObject, NSCoding{

    var aboutUs : String!
    var privacyPolicy : String!
    var status : Bool!
    var termsCondition : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        aboutUs = json["about_us"].stringValue
        privacyPolicy = json["privacy_policy"].stringValue
        status = json["status"].boolValue
        termsCondition = json["terms_condition"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if aboutUs != nil{
        	dictionary["about_us"] = aboutUs
        }
        if privacyPolicy != nil{
        	dictionary["privacy_policy"] = privacyPolicy
        }
        if status != nil{
        	dictionary["status"] = status
        }
        if termsCondition != nil{
        	dictionary["terms_condition"] = termsCondition
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		aboutUs = aDecoder.decodeObject(forKey: "about_us") as? String
		privacyPolicy = aDecoder.decodeObject(forKey: "privacy_policy") as? String
		status = aDecoder.decodeObject(forKey: "status") as? Bool
		termsCondition = aDecoder.decodeObject(forKey: "terms_condition") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if aboutUs != nil{
			aCoder.encode(aboutUs, forKey: "about_us")
		}
		if privacyPolicy != nil{
			aCoder.encode(privacyPolicy, forKey: "privacy_policy")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if termsCondition != nil{
			aCoder.encode(termsCondition, forKey: "terms_condition")
		}

	}

}
