//
//  RestaurantDetailsCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantDetailsCell: UITableViewCell ,ExpandableLabelDelegate{

    
    var customize : (() -> ())?
    var decreaseData : (() -> ())?
    var IncreseData : (() -> ())?
    var btnAddAction : (() -> ())?
    var ExpandedLabel : ((Int) -> ())?
    
    
    @IBOutlet weak var stackHide: UIStackView!
    @IBOutlet weak var vwRadius: UIView!
    @IBOutlet weak var vwSeperator: seperatorView!
    @IBOutlet weak var btnCustomize: underLineButton!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var lblAboutItem: ExpandableLabel!
    @IBOutlet weak var lblItemPrice: tblMyOrdersLabel!
    @IBOutlet weak var lblItemName: tblMyOrdersLabel!
    @IBOutlet weak var imgFoodDetails: UIImageView!
    @IBOutlet weak var lblNoOfItem: UILabel!
    @IBOutlet weak var vwStapper: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLocalizedStrings()
        SetExpandeLable()
    }

    
    @IBAction func btnCustomize(_ sender: Any) {
        if let click = self.customize {
            click()
        }
    }
    @IBAction func btnDecrease(_ sender: Any) {
        if let Decrease = self.decreaseData{
            Decrease()
        }
    }
    @IBAction func btnIncrease(_ sender: Any) {
        if let Increase = self.IncreseData{
            Increase()
        }
    }
    @IBAction func btnAdd(_ sender: Any) {
        if let btnAdd = self.btnAddAction{
            btnAdd()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUpLocalizedStrings(){
        btnCustomize.setTitle("RestaurantDetailsVC_RestaurantDetailsCell_btnCustomize".Localized(), for: .normal)
    }

    //Expandeble label
    
    func SetExpandeLable(){
        self.lblAboutItem.delegate = self
//        self.lblAboutItem.ellipsis = NSAttributedString(string: "...")
        
        let myAttribute =  [NSAttributedString.Key.foregroundColor:UIColor(hexString: "#E34A25"),NSAttributedString.Key.font: CustomFont.NexaBold.returnFont(12),NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue] as [NSAttributedString.Key : Any]
        
        let viewMoreString = NSAttributedString(string: "Show More", attributes: myAttribute)
        let viewLessString = NSAttributedString(string: "Show Less", attributes: myAttribute)
        
        self.lblAboutItem.collapsedAttributedLink = viewMoreString
        self.lblAboutItem.expandedAttributedLink = viewLessString
 
        self.lblAboutItem.shouldCollapse = true
//        lblAboutItem.textReplacementType = .word
        self.lblAboutItem.numberOfLines = 3
//        self.lblAboutItem.collapsed = true
    }
    
    
    func willExpandLabel(_ label: ExpandableLabel) {
        if label == lblAboutItem {
            lblAboutItem.numberOfLines = 0
            lblAboutItem.collapsed = false
            if let expandedLabel = ExpandedLabel{
                expandedLabel(0)
            }
            
        }
        
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        if label == lblAboutItem {
            
        } else {
            
        }
        
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        if label == lblAboutItem {
            lblAboutItem.numberOfLines = 3
            lblAboutItem.collapsed = true
            if let expandedLabel = ExpandedLabel{
                expandedLabel(3)
            }
            
        } else {
            
        }
        
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        if label == lblAboutItem {
            
        } else {
           
        }
        
    }
}
