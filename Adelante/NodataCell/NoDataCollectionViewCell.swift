//
//  NoDataCollectionViewCell.swift
//  MyLineup
//
//  Created by EWW077 on 06/05/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class NoDataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTapToadd: UILabel!
    @IBOutlet weak var lblNodataTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img.alpha = 0.5
        self.lblNodataTitle.alpha = 0.5
        
        lblNodataTitle.textColor = colors.black.value
        lblNodataTitle.font = CustomFont.NexaRegular.returnFont(17)
        
        // Initialization code
    }

}
