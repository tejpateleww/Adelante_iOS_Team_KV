//
//  PaymentWebViewVC.swift
//  Adelante
//
//  Created by Apple on 10/09/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit
import WebKit

class PaymentWebViewVC: BaseViewController, WKNavigationDelegate {
    
    //MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var strUrl = ""
    private let webView = WKWebView(frame: .zero)
    var strNavTitle = ""
    var strStorePolicy = ""
    var OrderID = ""
    
    var callBackURL = ""
    var cancelURL = ""
    // MARK: - IBOutlets
    @IBOutlet weak var vwWebMain: UIView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: strNavTitle, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.vwWebMain.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.vwWebMain.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.vwWebMain.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.vwWebMain.topAnchor),
        ])
        self.view.setNeedsLayout()
        
        webView.navigationDelegate = self
        let URLTemp = URL.init(string: strUrl)
        webView.load(URLRequest.init(url: URLTemp!))//load(URLRequest(url: URLTemp))
//        Utilities.showHud()
        webView.allowsBackForwardNavigationGestures = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.customTabBarController?.hideTabBar()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Utilities.hideHud()
        
        print("didFailProvisionalNavigation: \(String(describing: webView.url?.absoluteString))")
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        Utilities.hideHud()
        print("didFinish: \(String(describing: webView.url?.absoluteString))")
        
        let str = webView.url?.absoluteString ?? ""
        if str.contains("success") {
            vwWebMain.isHidden = true
            webView.isHidden = true
            let strArray = str.components(separatedBy: "//")
            let strUrl = strArray[1].components(separatedBy: "/")
            let strID = strUrl.last?.components(separatedBy: "?")
            self.OrderID = strID?.last ?? ""
            print(strID)
//            let strArray =  str.components(separatedBy: "/")
//            let str = strArray.last?.components(separatedBy: "?")
            //self.OrderID = str
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
            controller.isHideCancelButton = true
            controller.isHideSubmitButton = false
            controller.submitBtnTitle = "OK               "
            controller.cancelBtnTitle = ""
            controller.strDescription = "Your order has been placed"
            controller.strPopupTitle = "Payment Successful"
            controller.submitBtnColor = colors.appGreenColor
            controller.cancelBtnColor = colors.appRedColor
            controller.strPopupImage = "ic_popupPaymentSucessful"
            controller.isCancleOrder = true
//            self.socketManageSetup()
            if let homevc =  self.navigationController?.children.first as? HomeVC{
                homevc.orderIdArray.append(self.OrderID)
//                homevc.socketManageSetup()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.StartUpdateLocation), object: nil, userInfo: nil)
            }
            controller.btnSubmit = {
                if let TabVC =  appDel.window?.rootViewController?.children.first {
                    if TabVC.isKind(of: CustomTabBarVC.self) {
                        SingletonClass.sharedInstance.selectInProcessInMyOrder = true
                        let vc = TabVC as! CustomTabBarVC
                        vc.selectedIndex = 2
                    }
                }
            }
            self.present(controller, animated: true, completion: nil)
        }else if str.contains("failed"){
            vwWebMain.isHidden = true
            webView.isHidden = true
            let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: commonPopup.storyboardID) as! commonPopup
            controller.isHideCancelButton = true
            controller.isHideSubmitButton = false
            controller.submitBtnTitle = "OK               "
            controller.cancelBtnTitle = ""
            controller.strDescription = ""
            controller.strPopupTitle = "Payment Failed"
            controller.submitBtnColor = colors.appRedColor
            controller.cancelBtnColor = colors.appRedColor
            controller.strPopupImage = "Dummy_notif2"
            controller.isCancleOrder = true
            controller.btnSubmit = {
                self.navigationController?.popViewController(animated: true)
            }
            self.present(controller, animated: true, completion: nil)
        }
        if str == self.cancelURL {
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utilities.hideHud()
        print("didFail: \(String(describing: webView.url?.absoluteString))")
        // pop..
    }
}

//extension StringProtocol { // for Swift 4 you need to add the constrain `where Index == String.Index`
//    var byWords: [SubSequence] {
//        var byWords: [SubSequence] = []
//        enumerateSubstrings(in: startIndex..., options: .byWords) { , range, , _ in
//            byWords.append(self[range])
//        }
//        return byWords
//    }
//}
extension String {

    func trim(_ emptyToNil: Bool = true)->String? {
        let text = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return emptyToNil && text.isEmpty ? nil : text
    }

    var lastWord: String? {
        if let size = self.lastIndex(of: " "), size >= self.startIndex {
            return String(self[size...]).trim()
        }
        return nil
    }

}
