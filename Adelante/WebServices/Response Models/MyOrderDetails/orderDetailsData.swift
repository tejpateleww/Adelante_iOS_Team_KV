//
//  orderDetailsData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 5, 2021

import Foundation
import SwiftyJSON


class orderDetailsData : Codable{

    var mainOrder : MainOrder!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let mainOrderJson = json["main_order"]
        if !mainOrderJson.isEmpty{
            mainOrder = MainOrder(fromJson: mainOrderJson)
        }
	}


}
