//
//  UIStoryboard+Extension.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import UIKit
extension UIStoryboard {
    
    enum Storyboard: String {
        case Main
        case Authentication
    }
    
    // MARK: - Convenience Initializers
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    // MARK: - Public Methods
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(String(describing: T.self)) ")
        }
        return viewController
    }
    
}

