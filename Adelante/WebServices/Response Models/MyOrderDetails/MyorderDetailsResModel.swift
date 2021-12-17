//
//  MyorderDetailsResModel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class MyorderDetailsResModel : Codable{

    var data : orderDetailsData!
    var parkinglist : [Parkinglist]!
    var status : Bool!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = orderDetailsData(fromJson: dataJson)
        }
        parkinglist = [Parkinglist]()
        let itemArray = json["parking_list"].arrayValue
        for itemJson in itemArray{
            let value = Parkinglist(fromJson: itemJson)
            parkinglist.append(value)
        }
        status = json["status"].boolValue
	}

	

}
class Parkinglist : Codable{

    var id : String!
    var outlet_id : String!
    var parking_no : String!
    var status : Bool!
    var trash : String!
    var created_at : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        outlet_id = json["outlet_id"].stringValue
        parking_no = json["parking_no"].stringValue
        status = json["status"].boolValue
        trash = json["trash"].stringValue
        created_at = json["created_at"].stringValue
    }

    
}
