//
//  RestWithPageCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestWithPageCell: UICollectionViewCell {
    @IBOutlet weak var imgRestaurant: customImageView!
    @IBOutlet weak var lblRestName: colVwRestaurantLabel!
    @IBOutlet weak var lblRestDesc: colVwRestaurantLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLocalizedStrings()
    }
    
    func setUpLocalizedStrings(){
        lblRestName.text = "Lorem Ipsum"
        lblRestDesc.text = "Lorem Ipsum is simply dummy text"
    }
}
