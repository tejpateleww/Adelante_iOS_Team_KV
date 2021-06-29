//
//  Fonts.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import UIKit
enum CustomFont{
    
    case AileronLight, AileronBoldItalic, AileronThiItalic, AileronUltraLight, AileronHeavy, AileronUltraLightItalic, AileronLightItalic, AileronThin, AileronHeavyItalic, AileronSemiBoldItalic, AileronSemiBold, AileronBold, AileronItalic, AileronBlackItalic, AileronBlack, AileronRegular, NexaBlackItalic, NexaBookItalic, NexaBlack, NexaBoldItalic, NexaLightItalic, NexaThinItalic, NexaThin, NexaLight, NexaBold, NexaBook, NexaRegular, NunitoBlack, NunitoBlackItalic, NunitoBold, NunitoBoldItalic, NunitoExtraBold, NunitoExtraBoldItalic, NunitoExtraLight, NunitoExtraLightItalic, NunitoItalic, NunitoLight, NunitoLightItalic, NunitoRegular, NunitoSemiBold, NunitoSemiBoldItalic
    
    func returnFont(_ font:CGFloat)->UIFont{
        switch self {
        case .AileronLight:
            return UIFont(name: "Aileron-Light", size: font)!
        case .AileronBoldItalic:
            return UIFont(name: "Aileron-BoldItalic", size: font)!
        case .AileronThiItalic:
            return UIFont(name: "Aileron-ThinItalic", size: font)!
        case .AileronUltraLight:
            return UIFont(name: "Aileron-UltraLight", size: font)!
        case .AileronHeavy:
            return UIFont(name: "Aileron-Heavy", size: font)!
        case .AileronUltraLightItalic:
            return UIFont(name: "Aileron-UltraLightItalic", size: font)!
        case .AileronLightItalic:
            return UIFont(name: "Aileron-LightItalic", size: font)!
        case .AileronThin:
            return UIFont(name: "Aileron-Thin", size: font)!
        case .AileronHeavyItalic:
            return UIFont(name: "Aileron-HeavyItalic", size: font)!
        case .AileronSemiBoldItalic:
            return UIFont(name: "Aileron-SemiBoldItalic", size: font)!
        case .AileronSemiBold:
            return UIFont(name: "Aileron-SemiBold", size: font)!
        case .AileronBold:
            return UIFont(name: "Aileron-Bold", size: font)!
        case .AileronItalic:
            return UIFont(name: "Aileron-Italic", size: font)!
        case .AileronBlackItalic:
            return UIFont(name: "Aileron-BlackItalic", size: font)!
        case .AileronBlack:
            return UIFont(name: "Aileron-Black", size: font)!
        case .AileronRegular:
            return UIFont(name: "Aileron-Regular", size: font)!
            
        // Nexa
//        case .NexaBlackItalic:
//            return UIFont(name: "Nexa-BlackItalic", size: font)!
//        case .NexaBookItalic:
//            return UIFont(name: "Nexa-BookItalic", size: font)!
//        case .NexaBlack:
//            return UIFont(name: "Nexa-Black", size: font)!
//        case .NexaBoldItalic:
//            return UIFont(name: "Nexa-BoldItalic", size: font)!
//        case .NexaLightItalic:
//            return UIFont(name: "Nexa-LightItalic", size: font)!
//        case .NexaThinItalic:
//            return UIFont(name: "Nexa-ThinItalic", size: font)!
//        case .NexaThin:
//            return UIFont(name: "Nexa-Thin", size: font)!
//        case .NexaLight:
//            return UIFont(name: "Nexa-Light", size: font)!
//        case .NexaBold:
//            return UIFont(name: "NexaBold", size: font)!
//        case .NexaBook:
//            return UIFont(name: "Nexa-Book", size: font)!
//        case .NexaRegular:
//            return UIFont(name: "NexaRegular", size: font)!
            
        // Nunito Replacement
        case .NexaBlackItalic:
            return UIFont(name: "Nunito-BlackItalic", size: font)!
        case .NexaBookItalic:
            return UIFont(name: "Nunito-BookItalic", size: font)!
        case .NexaBlack:
            return UIFont(name: "Nunito-Black", size: font)!
        case .NexaBoldItalic:
            return UIFont(name: "Nunito-BoldItalic", size: font)!
        case .NexaLightItalic:
            return UIFont(name: "Nunito-LightItalic", size: font)!
        case .NexaThinItalic:
            return UIFont(name: "Nunito-ThinItalic", size: font)!
        case .NexaThin:
            return UIFont(name: "Nunito-Thin", size: font)!
        case .NexaLight:
            return UIFont(name: "Nunito-Light", size: font)!
        case .NexaBold:
            return UIFont(name: "Nunito-Bold", size: font)!
        case .NexaBook:
            return UIFont(name: "Nunito-Book", size: font)!
        case .NexaRegular:
            return UIFont(name: "Nunito-Regular", size: font)!
            
        // Nunito
        case .NunitoBlack:
            return UIFont(name: "Nunito-Black", size: font)!
        case .NunitoBlackItalic:
            return UIFont(name: "Nunito-BlackItalic", size: font)!
        case .NunitoBold:
            return UIFont(name: "Nunito-Bold", size: font)!
        case .NunitoBoldItalic:
            return UIFont(name: "Nunito-BoldItalic", size: font)!
        case .NunitoExtraBold:
            return UIFont(name: "Nunito-ExtraBold", size: font)!
        case .NunitoExtraBoldItalic:
            return UIFont(name: "Nunito-ExtraBoldItalic", size: font)!
        case .NunitoExtraLight:
            return UIFont(name: "Nunito-ExtraLight", size: font)!
        case .NunitoExtraLightItalic:
            return UIFont(name: "Nunito-ExtraLightItalic", size: font)!
        case .NunitoItalic:
            return UIFont(name: "Nunito-Italic", size: font)!
        case .NunitoLight:
            return UIFont(name: "Nunito-Light", size: font)!
        case .NunitoLightItalic:
            return UIFont(name: "Nunito-LightItalic", size: font)!
        case .NunitoRegular:
            return UIFont(name: "Nunito-Regular", size: font)!
        case .NunitoSemiBold:
            return UIFont(name: "Nunito-SemiBold", size: font)!
        case .NunitoSemiBoldItalic:
            return UIFont(name: "Nunito-SemiBoldItalic", size: font)!
        }
    }
}
