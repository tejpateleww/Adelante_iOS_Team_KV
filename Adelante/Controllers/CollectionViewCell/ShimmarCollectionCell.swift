//
//  ShimmarCollectionCell.swift
//  Adelante
//
//  Created by Ankur on 25/06/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class ShimmarCollectionCell: UICollectionViewCell {
    @IBOutlet weak var viewShimmer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        startShimmering()
//
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        viewShimmer.frame.size.width = contentView.frame.size.width
    }
    func startShimmering(){
        self.isSkeletonable = true
        viewShimmer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
    }
    
    func stopShimmering(){
        viewShimmer.hideSkeleton()
    }
}
