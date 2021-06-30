//
//  skeletonView.swift
//  Adelante
//
//  Created by Ankur on 29/06/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class skeletonView: UIView {
    @IBOutlet weak var lblShimmerText: UILabel!
    @IBOutlet weak var viewShimmer: UIView!
    @IBOutlet weak var viewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startShimmering()
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
