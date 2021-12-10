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
        Utilities.showHud()
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
            controller.strDescription = ""
            controller.strPopupTitle = "Payment Successful"
            controller.submitBtnColor = colors.appGreenColor
            controller.cancelBtnColor = colors.appRedColor
            controller.strPopupImage = "ic_popupPaymentSucessful"
            controller.isCancleOrder = true
            self.socketManageSetup()
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
extension PaymentWebViewVC{
    func socketManageSetup(){
        SocketIOManager.shared.establishSocketConnection()
        allSocketOffMethods()
        self.SocketOnMethods()
    }
    
    func SocketOnMethods() {
        
        SocketIOManager.shared.socket.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
            SocketIOManager.shared.isSocketOn = false
        }
        
        SocketIOManager.shared.socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected")
            SocketIOManager.shared.isSocketOn = true
            
        }
        
        
        print("===========\(SocketIOManager.shared.socket.status)========================",SocketIOManager.shared.socket.status.active)
        SocketIOManager.shared.socket.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            
            SocketIOManager.shared.isSocketOn = true
            //            self.allSocketOffMethods()
            self.emitSocketUserConnect()
            
            self.allSocketOnMethods()
            
        }
        //Connect User On Socket
        SocketIOManager.shared.establishConnection()
        //MARK: -====== Socket connection =======
        
        print("==============\(SocketIOManager.shared.socket.status)=====================",SocketIOManager.shared.socket.status.active)
        
        if SocketIOManager.shared.socket.status.active{
            self.allSocketOffMethods()
            self.emitSocketUserConnect()
            self.allSocketOnMethods()
        }
    }
    
    
    
    // ON ALL SOCKETS
    func allSocketOnMethods() {
        print("\n\n", #function, "\n\n")
        onSocketConnectUser()
        //        onSocket_SendMessage()
        onSocketUpdateLocation()
        
    }
    
    // OFF ALL SOCKETS
    func allSocketOffMethods() {
        print("\n\n", #function, "\n\n")
        SocketIOManager.shared.socket.off(SocketData.kConnectUser.rawValue)
        //        SocketIOManager.shared.socket.off(SocketKeys.SendMessage.rawValue)
        SocketIOManager.shared.socket.off(SocketData.kLocationTracking.rawValue)
    }
    
    //-------------------------------------
    // MARK:= SOCKET ON METHODS =
    //-------------------------------------
    func onSocketConnectUser(){
        SocketIOManager.shared.socketCall(for: SocketData.kConnectUser.rawValue) { (json) in
            print(#function, "\n ", json)
        }
    }
    
    
    func onSocketUpdateLocation(){
        SocketIOManager.shared.socketCall(for: SocketData.kLocationTracking.rawValue) { (json) in
        }
    }
    
    //-------------------------------------
    // MARK:= SOCKET EMIT METHODS =
    //-------------------------------------
    
    // Socket Emit Connect user
    func emitSocketUserConnect(){
        print(#function)
        //        customer_id,lat,lng
        let param: [String: Any] = ["customer_id" : SingletonClass.sharedInstance.UserId
        ]
        SocketIOManager.shared.socketEmit(for: SocketData.kConnectUser.rawValue, with: param)
        self.emitSocketUpdateLocation()
    }
    
    func emitSocketUpdateLocation() {
        print(#function)
        //        SocketIOManager.shared.socketEmit(for: SocketData.kDriverLocation.rawValue, with: [:])
        let param: [String: Any] = ["customer_id" : SingletonClass.sharedInstance.UserId,
                                    "order_id" : OrderID,
                                    "lat": SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude ,
                                    "lng" :SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude
        ]
        SocketIOManager.shared.socketEmit(for: SocketData.kLocationTracking.rawValue, with: param)
        
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
