//
//  commonPopup.swift
//  Adelante
//
//  Created by Apple on 08/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class commonPopup: UIViewController {
    
    
    var isCancleOrder : Bool = false
    var tap = UIGestureRecognizer()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var vwMain: viewWithClearBG!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblTitle: commonPopUPLabel!
    @IBOutlet weak var lblDescription: commonPopUPLabel!
    @IBOutlet weak var btnBGView: UIView!
    @IBOutlet weak var submitButton: commonPopupButton!
    @IBOutlet weak var btnCancel: commonPopupButton!
    
    var btnSubmit : (() -> ())?
    
    var isHideCancelButton = true
    var isHideSubmitButton = true
    var submitBtnTitle = ""
    var cancelBtnTitle = ""
    var strDescription = ""
    
    @IBOutlet weak var vwCancel: UIView!
    @IBOutlet weak var vwSubmit: UIView!
    
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
                backView.backgroundColor =  colors.white.value.withAlphaComponent(0.5)//UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)
                
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
                backView.backgroundColor =  colors.white.value.withAlphaComponent(0.5) //UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)
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
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        view.addGestureRecognizer(tap)
        
        
        imgStatus.image = UIImage(named: "ic_popupPaymentSucessful")
        lblTitle.text = "Payment Successful"
        lblDescription.text = "Your order has been placed."
        submitButton.setTitle("OK", for: .normal)
        submitButton.backgroundColor = colors.appGreenColor.value
        btnCancel.backgroundColor = colors.appGreenColor.value
        
        if isCancleOrder {
            imgStatus.image = UIImage(named: "ic_popupCancleOrder")
            lblTitle.text = "Are you Sure?"
            lblDescription.text = "Do you really want  to cancel the order?"
            submitButton.setTitle("Cancel Order", for: .normal)
            submitButton.backgroundColor = UIColor(hexString: "#FF172F")
            btnCancel.backgroundColor = UIColor(hexString: "#FF172F")
        }
        
        if submitBtnTitle != ""
        {
            submitButton.setTitle(submitBtnTitle, for: .normal)
        }
        if cancelBtnTitle != "" {
            btnCancel.setTitle(cancelBtnTitle, for: .normal)
        }
        if strDescription != ""
        {
            lblDescription.text = strDescription
        }
        self.vwCancel.isHidden = isHideCancelButton
        self.vwSubmit.isHidden = isHideSubmitButton
    }
    
    // MARK: - IBActions
    @objc func dismissView(_ gesture : UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
        view.removeGestureRecognizer(tap)
    }
    
    @IBAction func submitButtonAction(_ sender: commonPopupButton) {
        if let click = self.btnSubmit
        {
            click()
        }
    }
    
    @IBAction func btnCancelAction(_ sender: commonPopupButton) {
            self.dismiss(animated: true, completion: nil)
            view.removeGestureRecognizer(tap)
    }
}
