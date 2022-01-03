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
    }
    func setDataImage(image:String) {
        let Mainview  = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        let imageView = UIImageView(frame:CGRect(x: 0 , y: 0, width: 140, height: 140))
        imageView.center = CGPoint(x: Mainview.frame.size.width / 2, y: Mainview.frame.size.height / 2)
        imageView.image = UIImage(named: image)
        Mainview.addSubview(imageView)
        self.backgroundView = Mainview
    }
    func restore() {
        self.backgroundView = nil
//        self.separatorStyle = .singleLine
    }
}
