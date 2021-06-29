//
//  ShimmerCell.swift
//  Adelante
//
//  Created by Ankur on 25/06/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class ShimmerCell: UITableViewCell {
    @IBOutlet weak var lblShimmerText: UILabel!
    @IBOutlet weak var viewShimmer: UIView!
    @IBOutlet weak var viewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        startShimmering()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func startShimmering(){
        self.isSkeletonable = true
        viewContainer.layer.cornerRadius = 20
        
        viewContainer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblShimmerText.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        viewShimmer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
    }
    
    func stopShimmering(){
        viewContainer.hideSkeleton()
        lblShimmerText.hideSkeleton()
        viewShimmer.hideSkeleton()
    }
}
