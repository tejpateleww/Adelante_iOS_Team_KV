//
//  QRCodeVC.swift
//  Adelante
//
//  Created by Harsh Dave on 23/11/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

class QRCodeVC: BaseViewController {
    var customTabBarController: CustomTabBarVC?
    var qrImage : UIImage? = UIImage()
    @IBOutlet weak var imgQrCode: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgQrCode.image = qrImage
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: "QRCode", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
