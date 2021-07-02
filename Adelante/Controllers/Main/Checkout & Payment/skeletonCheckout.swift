//
//  skeletonCheckout.swift
//  Adelante
//
//  Created by Harsh Dave on 02/07/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class skeletonCheckout: UIView {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewShimmer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDisc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        startShimmering()
    }
    func startShimmering(){
        viewContainer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        viewShimmer.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblTitle.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
        lblDisc.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: skeletonAnimation)
    }
    func stopShimmering(){
        viewContainer.hideSkeleton()
        viewShimmer.hideSkeleton()
        lblTitle.hideSkeleton()
        lblDisc.hideSkeleton()
    }
}
