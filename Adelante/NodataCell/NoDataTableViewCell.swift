//
//  NoDataTableViewCell.swift
//  MyLineup
//
//  Created by EWW077 on 25/03/20.
//  Copyright © 2020 Mayur iMac. All rights reserved.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {

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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
