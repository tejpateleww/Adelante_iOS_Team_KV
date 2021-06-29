//
//  HomeSkeletonCell.swift
//  Adelante
//
//  Created by Ankur on 28/06/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class HomeSkeletonCell: UITableViewCell {

    @IBOutlet weak var lblShimmerText: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
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
//        lblShimmerText.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblTitle.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        viewShimmer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
    }
    
    func stopShimmering(){
        lblTitle.hideSkeleton()
        viewContainer.hideSkeleton()
//        lblShimmerText.hideSkeleton()
        viewShimmer.hideSkeleton()
    }
    
}
