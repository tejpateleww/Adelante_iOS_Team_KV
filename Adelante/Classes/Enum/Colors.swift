//
//  Colors.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import  UIKit

enum colors{
    case white,black, red, appOrangeColor,appGreenColor, badgeColor, segmentSelectedColor, segmentDeselectedColor, searchBarBg, submitButtonShadow, textFieldColor
    
    var value:UIColor{
        switch self {
        case .white:
            return UIColor.white
        case .black:
            return UIColor.black
        case .red:
            return UIColor.red
        case .appOrangeColor:
            return UIColor(hexString: "#E34A25")
        case .appGreenColor:
            return UIColor(hexString: "#209413")
        case .badgeColor:
            return UIColor(hexString: "#DFB23C")
        case .segmentSelectedColor:
            return UIColor(hexString: "#D3D8DF")
        case .segmentDeselectedColor:
            return UIColor(hexString: "#F3F5F9")
        case .searchBarBg:
            return UIColor(hexString: "#CFD5E5")
        case .submitButtonShadow:
            return UIColor(hexString: "#3E1F43")
        case .textFieldColor:
            return UIColor(hexString: "#9597A8")
        }
    }
}
