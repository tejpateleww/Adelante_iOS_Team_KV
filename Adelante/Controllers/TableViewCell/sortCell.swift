//
//  sortCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class sortCell: UITableViewCell {

    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var SortListName: UILabel!
    var btnClickNew : (() -> ())?
    

    @IBAction func btnClick(_ sender: Any) {
        if let click = self.btnClickNew
        {
            click()
        }
    }

}
