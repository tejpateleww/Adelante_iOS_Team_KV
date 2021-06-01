//
//  NoData.swift
//  Adelante
//
//  Created by Apple on 31/05/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
enum NoData {
    case Favorite, promocode,varient,pastorder,inorder
    
    var ImageName:String {
        switch self {
        case .Favorite:
            return ""
        case .promocode:
            return ""
        case .varient:
            return ""
        case .pastorder:
            return ""
        case .inorder:
            return ""
        
        }
    }
}
