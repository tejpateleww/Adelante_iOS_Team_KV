//
//  AddCardReqModel.swift
//  Adelante
//
//  Created by baps on 02/02/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
class AddCardReqModel:RequestModel{
    var user_id : String = ""
    var card_num : String = ""
    var card_holder_name : String = ""
    var exp_date_month_year : String = ""
    var cvv : String = ""
}
