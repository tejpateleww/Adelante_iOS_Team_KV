//
//  AddCardVC.swift
//  Adelante
//
//  Created by Apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class AddCardVC: BaseViewController {
    // MARK: - Properties
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblName: addCardLabel!
    @IBOutlet weak var txtName: addCarddetailsTextField!
    @IBOutlet weak var lblCardNumber: addCardLabel!
    @IBOutlet weak var txtCardNumber: addCarddetailsTextField!
    @IBOutlet weak var lblExpires: addCardLabel!
    @IBOutlet weak var txtDate: addCarddetailsTextField!
    @IBOutlet weak var lblCvv: addCardLabel!
    @IBOutlet weak var txtCvv: addCarddetailsTextField!
    @IBOutlet weak var lblDebitcardDetail: addCardLabel!
    @IBOutlet weak var btnSave: submitButton!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.AddCardVC.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Other Methods
    
    // MARK: - IBActions
  @IBAction func placeOrderBtn(_ sender: submitButton) {
    self.navigationController?.popViewController(animated: true)
//             let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BffComboVC.storyboardID)
//             self.navigationController?.pushViewController(controller, animated: true)
         }
    func setUpLocalizedStrings(){
        lblName.text = "AddCardVC_lblName".Localized()
        txtName.placeholder = "AddCardVC_txtName".Localized()
        lblCardNumber.text = "AddCardVC_lblCardNumber".Localized()
        txtCardNumber.placeholder = "AddCardVC_txtCardNumber".Localized()
        lblExpires.text = "AddCardVC_lblExpires".Localized()
        txtDate.placeholder = "AddCardVC_txtDate".Localized()
        lblCvv.text = "AddCardVC_lblCvv".Localized()
        txtCvv.placeholder = "AddCardVC_txtCvv".Localized()
        lblDebitcardDetail.text = "AddCardVC_lblDebitcardDetail".Localized()
        btnSave.setTitle("AddCardVC_btnSave".Localized(), for: .normal)
    }
    // MARK: - Api Calls
}
