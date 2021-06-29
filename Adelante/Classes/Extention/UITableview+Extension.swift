//
//  UITableview+Extension.swift
//  Adelante
//
//  Created by baps on 25/01/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import UIKit
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = colors.black.value.withAlphaComponent(0.5)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = CustomFont.NexaBold.returnFont(15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
//        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
//        self.separatorStyle = .singleLine
    }
}
