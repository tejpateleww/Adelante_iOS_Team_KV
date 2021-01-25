//
//  EditLocationVC.swift
//  Adelante
//
//  Created by baps on 25/01/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class EditLocationVC: BaseViewController {
    
    @IBOutlet weak var txtSearch: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setUpLocalizedStrings()
        txtSearch.backgroundImage = UIImage()
    }
    func setup(){
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.EditLocationVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deselectFilterOptionRest"), object: nil)
    }
    func setUpLocalizedStrings() {
        txtSearch.placeholder = "EditLocationVC_txtSearch".Localized()
    }
}
