//
//  CommonWebViewVC.swift
//  Adelante
//
//  Created by baps on 02/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import WebKit

class CommonWebViewVC: BaseViewController, WKNavigationDelegate {
    
    //MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var strUrl = "https://www.google.com"
    private let webView = WKWebView(frame: .zero)
    var strNavTitle = ""
    
    // MARK: - IBOutlets
    @IBOutlet weak var vwWebMain: UIView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
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
        let request = URLRequest(url: URL.init(string: strUrl)!)
        self.webView.navigationDelegate = self
        self.webView.load(request)
        Utilities.showHud()
    }
    override func viewWillAppear(_ animated: Bool) {
              self.customTabBarController?.hideTabBar()
          }
    // MARK: - IBActions
    
    // MARK: - Api Calls
}
