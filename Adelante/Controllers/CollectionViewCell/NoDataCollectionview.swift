//
//  NoDataCollectionview.swift
//  Adelante
//
//  Created by Ankur on 25/06/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class NoDataCollectionview: UICollectionViewCell {
    @IBOutlet weak var imgNoData: UIImageView!
    @IBOutlet weak var lblNoDataTitle: UILabel!
    @IBOutlet weak var lblTapToadd: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgNoData.alpha = 0.5
        self.lblNoDataTitle.alpha = 0.5
        
        lblNoDataTitle.textColor = colors.black.value
        lblNoDataTitle.font = CustomFont.NexaRegular.returnFont(17)
        
        lblTapToadd.isHidden = true
        // Initialization code
    }
    
}
