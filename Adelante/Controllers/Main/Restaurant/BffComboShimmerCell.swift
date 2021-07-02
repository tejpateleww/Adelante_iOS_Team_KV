//
//  BffComboShimmerCell.swift
//  Adelante
//
//  Created by Harsh Dave on 02/07/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class BffComboShimmerCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblShimmer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.clipsToBounds = true
        lblShimmer.clipsToBounds = true
        startShimmering()
        // Initialization code
    }
    func startShimmering(){
        viewContainer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblShimmer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
    }
    func stopShimmering(){
        viewContainer.hideSkeleton()
        lblShimmer.hideSkeleton()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
