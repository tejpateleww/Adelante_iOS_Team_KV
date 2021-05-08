//
//  PromocodeVC.swift
//  Adelante
//
//  Created by Admin on 06/05/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

class PromocodeVC: BaseViewController {
    var customTabBarController: CustomTabBarVC?

    @IBOutlet weak var tblPromoCode: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPromoCode.delegate = self
        tblPromoCode.dataSource = self
        tblPromoCode.reloadData()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.PromocodeVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
}
extension PromocodeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PromocodeCell = tblPromoCode.dequeueReusableCell(withIdentifier: PromocodeCell.reuseIdentifier, for: indexPath)as! PromocodeCell
        return cell
    }
}
