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
<<<<<<< HEAD
    case white,black, red, appOrangeColor,appGreenColor, badgeColor, segmentSelectedColor, segmentDeselectedColor, searchBarBg, submitButtonShadow, textFieldColor, myLocTitleHome, myLocValueHome, selectedFilterBtn, normalFilterBtn
=======
    case white,black, red, appOrangeColor,appGreenColor, badgeColor, segmentSelectedColor, segmentDeselectedColor, searchBarBg, submitButtonShadow, textFieldColor, clearCol,titleColor
>>>>>>> d54e4d40b838dd1d54ee3d2e20c953490db17001
    
    var value:UIColor{
        switch self {
        case .clearCol:
            return UIColor.clear
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
<<<<<<< HEAD
        case .myLocTitleHome:
            return UIColor(hexString: "#697782")
        case .myLocValueHome:
            return UIColor(hexString: "#353535")
        case .selectedFilterBtn:
            return UIColor(hexString: "#D3D8DF")
        case .normalFilterBtn:
            return UIColor(hexString: "#F3F5F9")
=======
        case .titleColor:
            return UIColor(hexString: "#9597a8")
>>>>>>> d54e4d40b838dd1d54ee3d2e20c953490db17001
        }
    }
}
