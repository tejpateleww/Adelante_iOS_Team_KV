//
//  SkeletonOrderDetails.swift
//  Adelante
//
//  Created by Harsh Dave on 01/07/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class SkeletonOrderDetails: UIView {
    @IBOutlet weak var lblShimmerText: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblDiscOne: UILabel!
    @IBOutlet weak var lblDiscTwo: UILabel!
    @IBOutlet weak var lblDiscThree: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.clipsToBounds = true
        lblShimmerText.clipsToBounds = true
        startShimmering()
    }
    func startShimmering(){
        self.isSkeletonable = true
        viewContainer.layer.cornerRadius = 20
        viewContainer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblShimmerText.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblDiscOne.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblDiscTwo.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblDiscThree.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
    }
    
    func stopShimmering(){
        viewContainer.hideSkeleton()
        lblShimmerText.hideSkeleton()
        lblDiscOne.hideSkeleton()
        lblDiscTwo.hideSkeleton()
        lblDiscThree.hideSkeleton()
    }

}
