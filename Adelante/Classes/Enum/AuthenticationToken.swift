//
//  AuthenticationToken.swift
//  CoreSound
//
//  Created by EWW083 on 05/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import UIKit

enum AuthenticationToken:Int{
    
    case user
    
    static var mapper: [AuthenticationToken: String] = [
        .user: ""
    ]
    var string: String {
        return AuthenticationToken.mapper[self]!
    }
    
}
import Alamofire

enum ParaEncoding :Int{
    case urlDefault
    case urlQueryString
    case jsonDefault
    
    static var mapper: [ParaEncoding: ParameterEncoding] = [
        .urlDefault: URLEncoding.default,
        .urlQueryString: URLEncoding.queryString,
        .jsonDefault: JSONEncoding.default
    ]
    
    var value: ParameterEncoding {
        return ParaEncoding.mapper[self]!
    }
}
