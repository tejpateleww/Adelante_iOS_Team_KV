//
//  MyOrdersCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class MyOrdersCell: UITableViewCell {
    // MARK: - IBOutlets of MyOrdersCell

     @IBOutlet weak var vwShare: UIView!
     @IBOutlet weak var vwRepeatOrder: UIView!
     @IBOutlet weak var vwCancelOrder: UIView!
     @IBOutlet weak var imgRestaurant: customImageView!
     @IBOutlet weak var lblRestName: tblMyOrdersLabel!
     @IBOutlet weak var lblRestLocation: tblMyOrdersLabel!
     @IBOutlet weak var lblPrice: tblMyOrdersLabel!
     @IBOutlet weak var btnShare: UIButton!
     @IBOutlet weak var lblItem: tblMyOrdersLabel!
     @IBOutlet weak var lblDtTime: tblMyOrdersLabel!
     @IBOutlet weak var btnRepeatOrder: myOrdersBtn!
     @IBOutlet weak var btnCancelOrder: myOrdersBtn!
     
     // MARK: - Properties
     var cancel : (() -> ())?
     var Repeat : (() -> ())?
     @IBAction func btnCancel(_ sender: myOrdersBtn) {
         if let click = self.cancel {
             click()
         }
     }
     @IBAction func btnRepeat(_ sender: myOrdersBtn) {
         if let click = self.Repeat {
             click()
         }
     }
     
     override func awakeFromNib() {
         super.awakeFromNib()
        setUpLocalizedStrings()
     }
    
     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
    
    func setUpLocalizedStrings() {
        btnRepeatOrder.setTitle("MyOrderVC_MyOrdersCess_btnRepeatOrder".Localized(), for: .normal)
        btnCancelOrder.setTitle("MyOrderVC_MyOrdersCess_btnCancelOrder".Localized(), for: .normal)
    }
    
}
