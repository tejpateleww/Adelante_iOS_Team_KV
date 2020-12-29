//
//  EditProfileVC.swift
//  Adelante
//
//  Created by baps on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileVC: BaseViewController{
    
    // MARK: - Properties
    private var imagePicker: ImagePicker!
    var selectedImage : UIImage?
    var customTabBarController: CustomTabBarVC?
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnUpdatePicture: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!{ didSet{ imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2}}
    @IBOutlet weak var txtFirstName: floatTextField!
    @IBOutlet weak var txtLastName: floatTextField!
    @IBOutlet weak var txtEmail: floatTextField!
    @IBOutlet weak var lblVerified: themeLabel!
    @IBOutlet weak var txtPhoneNumber: floatTextField!
    @IBOutlet weak var lblUnverified: themeLabel!
    @IBOutlet weak var btnSave: submitButton!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        setUp()
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.editProfile.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing : false)
    }
    override func viewWillAppear(_ animated: Bool) {
           self.customTabBarController?.hideTabBar()
       }
    // MARK: - IBActions
    @IBAction func btnProfilePicTap(_ sender: UIButton)
    {
        self.imagePicker.present(from: self.imgProfile, viewPresented: self.view)
    }
    
    @IBAction func Btnsave(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setUpLocalizedStrings() {
        txtFirstName.placeholder = "EditProfileVC_txtFirstName".Localized()
        txtLastName.placeholder = "EditProfileVC_txtLastName".Localized()
        txtEmail.placeholder = "EditProfileVC_txtEmail".Localized()
        lblVerified.text = "EditProfileVC_lblVerified".Localized()
        txtPhoneNumber.placeholder = "EditProfileVC_txtPhoneNumber".Localized()
        lblUnverified.text = "EditProfileVC_lblUnverified".Localized()
        btnSave.setTitle("EditProfileVC_btnSave".Localized(), for: .normal)
    }
    
    // MARK: - Api Calls
}

// MARK: - ImagePickerDelegate
extension EditProfileVC:ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag:Int) {
    }
}
