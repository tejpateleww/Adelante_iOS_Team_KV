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
    @IBOutlet weak var viewImageOne: UIView!
    @IBOutlet weak var viewImageTwo: UIView!
    @IBOutlet weak var viewImageTHree: UIView!
    @IBOutlet weak var lblDiscOne: UILabel!
    @IBOutlet weak var lblDiscTwo: UILabel!
    @IBOutlet weak var lblDiscThree: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.clipsToBounds = true
        lblShimmerText.clipsToBounds = true
        viewShimmer.clipsToBounds = true
        startShimmering()
    }
    func startShimmering(){
        self.isSkeletonable = true
        viewContainer.layer.cornerRadius = 20
        viewContainer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblShimmerText.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        viewShimmer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        viewImageOne.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        viewImageTwo.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        viewImageTHree.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblDiscOne.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblDiscTwo.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblDiscThree.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
    }
    
    func stopShimmering(){
        viewContainer.hideSkeleton()
        lblShimmerText.hideSkeleton()
        viewShimmer.hideSkeleton()
        viewImageOne.hideSkeleton()
        viewImageTwo.hideSkeleton()
        viewImageTHree.hideSkeleton()
        lblDiscOne.hideSkeleton()
        lblDiscTwo.hideSkeleton()
        lblDiscThree.hideSkeleton()
    }
}
