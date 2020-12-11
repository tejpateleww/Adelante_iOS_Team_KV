//
//  UIViewController+Extension.swift
//  Qwnched-Delivery
//
//  Created by EWW074 - Sj's iMAC on 26/08/20.
//  Copyright © 2020 EWW074. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func setNavBarWithMenuORBack(Title:String,LetfBtn : String, IsNeedRightButton:Bool , RightButton : String,isTranslucent : Bool , TintColour : UIColor = UIColor.white , TitleColour : UIColor)
    {
        self.navigationItem.title = Title//.uppercased()
        self.navigationController?.isNavigationBarHidden = false
        //    self.navigationController?.navigationBar.isOpaque = false
        self.navigationController?.navigationBar.barTintColor = colors.appOrangeColor.value
        self.navigationController?.navigationBar.tintColor = TintColour
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : TitleColour , NSAttributedString.Key.font : CustomFont.NexaBold.returnFont(20.0)]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if LetfBtn == "Hide" {
            navigationItem.hidesBackButton = true
        }
        
        if IsNeedRightButton == true
        {
            let button1 = UIButton(type: UIButton.ButtonType.custom)
            button1.setImage(UIImage(), for:.normal)
            button1.imageView?.contentMode = .scaleAspectFit
            button1.addTarget(self, action: #selector(BtnAction), for:.touchUpInside)
            button1.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            let barButton1 = UIBarButtonItem(customView: button1)
            
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem =  barButton1
        }
    }
    
    @objc func BtnAction(){
        
    }
    
    func addNavBarImage(isLeft:Bool, isRight:Bool) {
        if isLeft {
            var w = 133
            var h = 91
            if DeviceType.hasTopNotch {
                w = 173
                h = 106
            }
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: w, height: h))
            img.image = UIImage(named: "nav_leftCorner.png")
            self.view.addSubview(img)
//            img.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//            img.heightAnchor.constraint(equalToConstant: 106).isActive = true
//            img.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            
        }
        if isRight {
            var w = 90
            var h = 30 //25
            if DeviceType.hasTopNotch {
                w = 110
                h = 40
            }
            let img = UIImageView(frame: CGRect(x: Int(self.view.frame.size.width) - w, y: 0, width: w, height: h))
            img.image = UIImage(named: "nav_rightCorner.png")
            self.view.addSubview(img)
//            img.translatesAutoresizingMaskIntoConstraints = false
//            img.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//            img.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            img.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            
        }
    }
}
// MARK: EXTENSION

var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)

extension UIViewController {
    
    // MARK: IS SWIPABLE - FUNCTION
    func isSwipable(view:UIView) {
         //self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDrage(_:))))
         view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:))))
        
        //self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func isDragDown(view:UIView){
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .down
        view.addGestureRecognizer(slideDown)
    }
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        
        UIView.animate(withDuration: 0.1) {
            
           // self.dismiss(animated: true, completion: nil)
            if let theWindow = UIApplication.shared.keyWindow {
                gesture.view?.frame = CGRect(x:theWindow.frame.width - 15 , y: theWindow.frame.height - 15, width: 10 , height: 10)
            }
        }
    }
    
  
    // MARK:  swipe down to hide - FUNCTION
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                print(">0",touchPoint)
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                print(">100",touchPoint)
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name("deselectFilterOptionHome"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("deselectFilterOptionRest"), object: nil)
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    }
