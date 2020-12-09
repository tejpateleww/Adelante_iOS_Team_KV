//
//  AddCardVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class AddCardVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.AddCardVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        // Do any additional setup after loading the view.
    }
    

  @IBAction func placeOrderBtn(_ sender: submitButton) {
    self.navigationController?.popViewController(animated: true)
//             let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID)
//             self.navigationController?.pushViewController(controller, animated: true)
         }

}
