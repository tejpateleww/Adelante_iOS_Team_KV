//
//  CommonWebViewVC.swift
//  Adelante
//
//  Created by baps on 02/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import WebKit

class CommonWebViewVC: UIViewController,WKNavigationDelegate {
    var strUrl = "https://www.google.com"
    private let webView = WKWebView(frame: .zero)
    @IBOutlet weak var vwWebMain: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    func setUp() {
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
}
