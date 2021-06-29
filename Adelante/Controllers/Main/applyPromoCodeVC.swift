//
//  applyPromoCodeVC.swift
//  Adelante
//
//  Created by Apple on 11/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class applyPromoCodeVC: UIViewController {
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var tap = UIGestureRecognizer()
      var btnOk : (() -> ())?
    // MARK: - IBOutlets
    @IBOutlet weak var vwMain: viewWithClearBG!
   @IBOutlet weak var okButton: applyPromoCodeButtton!
       @IBOutlet weak var cancleButton: applyPromoCodeButtton!
    
    
    // MARK: - UIView Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBlurView()
        setUp()
    }
    
    
    // MARK: - Other Methods
    
    
    func setUpBlurView() {
        //        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        
        //If iOS 13 is available, add blur effect:
        if #available(iOS 13.0, *) {
            //check if transparency is reduced in system accessibility settings..
            if UIAccessibility.isReduceTransparencyEnabled == true {
                
            } else {
                let backView = UIView(frame: self.view.bounds)
                backView.backgroundColor =  colors.black.value.withAlphaComponent(0.2)//UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)
                
                self.view.addSubview(backView)
                
                let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
                let bluredEffectView = UIVisualEffectView(effect: blurEffect)
                bluredEffectView.frame = self.view.bounds
                
                let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
                let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                vibrancyEffectView.frame = bluredEffectView.bounds
                
                bluredEffectView.layer.masksToBounds = true
                bluredEffectView.contentView.addSubview(vibrancyEffectView)
                self.view.addSubview(bluredEffectView)
                self.view.bringSubviewToFront(vwMain)
            }
        } else {
            if UIAccessibility.isReduceTransparencyEnabled == true {
                
            } else {
                
                let backView = UIView(frame: self.view.bounds)
                backView.backgroundColor =  colors.black.value.withAlphaComponent(0.2) //UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)
                self.view.addSubview(backView)
                let blurEffect = UIBlurEffect(style: .dark)
                let bluredEffectView = UIVisualEffectView(effect: blurEffect)
                bluredEffectView.frame = self.view.bounds
                
                let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
                let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                vibrancyEffectView.frame = bluredEffectView.bounds
                
                bluredEffectView.layer.masksToBounds = true
                bluredEffectView.contentView.addSubview(vibrancyEffectView)
                self.view.addSubview(bluredEffectView)
                self.view.bringSubviewToFront(vwMain)
            }
        }
        
    }
    func setUp() {
       // tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
      //  view.addGestureRecognizer(tap)
        
        
        
    }
    // MARK: - IBActions
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
        view.removeGestureRecognizer(tap)
    }
    @IBAction func okButtonAction(_ sender: commonPopupButton) {
          if let click = self.btnOk
          {
              click()
          }
      }
    @IBAction func CancleButtonAction(_ sender: commonPopupButton) {
        self.dismiss(animated: true, completion: nil)
         }
    // MARK: - Api Calls
}
