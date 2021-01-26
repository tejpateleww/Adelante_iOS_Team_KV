//
//  CustomTabBarVC.swift
//  corner&shadowTabbar
//

import UIKit

//protocol CustomTabBarDelegate {
//    func didSelectItem()
//}

var selectedTabIndex = 2
class CustomTabBarVC: UITabBarController, UITabBarControllerDelegate {
    var lastSelectedIndex = 0
    let coustmeTabBarView:UIView = {
        //  daclare coustmeTabBarView as view
        let view = UIView(frame: .zero)
        
        // to make the cornerRadius of coustmeTabBarView
//        if #available(iOS 12.0, *) {
//            if view.traitCollection.userInterfaceStyle == .dark {
//                view.backgroundColor = colors.CommonBgColor.value
//            } else {
//                view.backgroundColor = colors.white.value
//            }
//        } else {
//            view.backgroundColor = colors.white.value
//        }
        
        view.backgroundColor = colors.white.value
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        // to make the shadow of coustmeTabBarView
        view.layer.masksToBounds = false
        view.layer.shadowColor = colors.black.value.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 10.0
        return view
    }()

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//    if let previousTrait = previousTraitCollection {
//        if #available(iOS 12.0, *) {
//            if UIApplication.shared.applicationState == .background {
//                if previousTrait.userInterfaceStyle == .dark {
//                    self.view.backgroundColor = colors.white.value
//                } else {
//                    self.view.backgroundColor = colors.CommonBgColor.value
//                }
//            }
//        } else {
//            self.view.backgroundColor = colors.white.value
//        }
//}
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 0
        addcoustmeTabBarView()
        hideTabBarBorder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var h = tabBar.frame.height + 12
        if #available(iOS 13.0, *) {
            h = tabBar.frame.height + 25
        }

        coustmeTabBarView.layer.cornerRadius = 8
        coustmeTabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        coustmeTabBarView.clipsToBounds = true
        
        // to make the shadow of coustmeTabBarView
        coustmeTabBarView.layer.masksToBounds = false
        coustmeTabBarView.layer.shadowColor = colors.black.value.cgColor
        coustmeTabBarView.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        coustmeTabBarView.layer.shadowOpacity = 0.12
        coustmeTabBarView.layer.shadowRadius = 10.0
        
//        if DeviceType.hasTopNotch{
//            if #available(iOS 13.0, *){
//                h = tabBar.frame.height + 25
//            }
////            if !DeviceType.IS_IPHONE_X {
////                h = tabBar.frame.height + 25
////            }
//        } else {
//            if #available(iOS 13.0, *){
//                h = tabBar.frame.height + 25
//            }
//        }
        
        let tabBarFrame = CGRect(x: tabBar.frame.origin.x, y: view.frame.height - h, width: tabBar.frame.width, height: h)
        tabBar.frame = tabBarFrame
        coustmeTabBarView.frame = tabBar.frame
        let normalTitleFont = CustomFont.NexaBlack.returnFont(13)
        for vc in self.viewControllers! {
            vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: normalTitleFont], for: .normal)
        }
        
        for vc in self.viewControllers! {
            vc.tabBarItem.title = nil
            if DeviceType.hasTopNotch && !DeviceType.IS_IPHONE_X {
                    vc.tabBarItem.imageInsets = UIEdgeInsets(top: 16.0, left: 0.0, bottom: -16.0, right: 0.0)
                } else {
                    vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
                }
            }
        
//        for vc in self.viewControllers! {
//            if DeviceType.hasTopNotch {
//                vc.tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: 0.0, bottom: 5.0, right: 0.0)
//            } else {
//                vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//            }
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var newSafeArea = UIEdgeInsets()

        // Adjust the safe area to the height of the bottom views.
        newSafeArea.bottom += coustmeTabBarView.bounds.size.height

        // Adjust the safe area insets of the
        //  embedded child view controller.
//        self.children.forEach({$0.additionalSafeAreaInsets = newSafeArea})
    }

    private func addcoustmeTabBarView() {
        //
        coustmeTabBarView.frame = tabBar.frame
        view.addSubview(coustmeTabBarView)
        view.bringSubviewToFront(self.tabBar)
    }
    
    func hideTabBarBorder() {
        let tabBar = self.tabBar
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
    }
    
    func hideTabBar() {
        self.tabBar.isHidden = true
        coustmeTabBarView.isHidden = true
    }

    func showTabBar() {
        self.tabBar.isHidden = false
        coustmeTabBarView.isHidden = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        lastSelectedIndex = tabBarController.selectedIndex
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let i = tabBarController.selectedIndex
        print("Selected Index: \(i)")
        
        selectedTabIndex = tabBarController.selectedIndex
        if (tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3 || tabBarController.selectedIndex == 4) {
            if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) == nil || (userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false){
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            self.present(navController, animated: true, completion: nil)
                appDel.clearData()
                SingletonClass.sharedInstance.isFromCustomTab = true
            tabBarController.selectedIndex = lastSelectedIndex
            }
        }
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
