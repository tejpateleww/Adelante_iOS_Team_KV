//
//  NotificationType.swift
//  Adelante
//
//  Created by Apple on 27/05/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
enum PushNotifications {
    
    case logout
    
    var Name:String {
        switch self {
       
        case .logout:
            return "logout"
       
        }
    }
}
