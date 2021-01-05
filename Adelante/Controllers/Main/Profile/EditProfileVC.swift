//
//  EditProfileVC.swift
//  Adelante
//
//  Created by baps on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileVC: BaseViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    // MARK: - Properties
    var selectedImage : UIImage?
    var customTabBarController: CustomTabBarVC?
    var imageupload = UIImagePickerController()
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
//        imgProfile.layer.cornerRadius = imgProfile.layer.bounds.height / 2
        imageupload.delegate = self
        imageupload.sourceType = .photoLibrary
        imageupload.allowsEditing = false
        setUpLocalizedStrings()
        setUp()
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.editProfile.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
      
    }
    override func viewWillAppear(_ animated: Bool) {
           self.customTabBarController?.hideTabBar()
       }
    // MARK: - IBActions
    @IBAction func btnProfilePicTap(_ sender: UIButton)
    {
        AlertSheet1()
    }
    
    @IBAction func Btnsave(_ sender: Any) {
        webserviceForEditprofile()
//        self.navigationController?.popViewController(animated: true)
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
    func webserviceForEditprofile()
    {
        let EditProfile = EditProfileReqModel()
        //EditProfile.email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        EditProfile.first_name = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        EditProfile.last_name = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        //EditProfile.phone = txtPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        EditProfile.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.UpdateProfileInfo(editProfileModel: EditProfile, img: selectedImage ?? UIImage(), showHud: false, completion: { (response, status, error) in
            if status{
                let updatedData = Profile.init(fromJson: response)
                SingletonClass.sharedInstance.LoginRegisterUpdateData = updatedData
               // userDefault.setUserData()
                Utilities.ShowAlert(OfMessage: response["message"].stringValue)
                self.setUpdate(to: false)
                self.btnUpdatePicture.setImage(#imageLiteral(resourceName: "EditProfilePhoto"), for: .normal)
                self.showUserData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func setUpdate(to enable : Bool ){
        txtFirstName.isEnabled = enable
        txtLastName.isEnabled = enable
        txtPhoneNumber.isEnabled = enable
        btnUpdatePicture.isEnabled = enable
    }
    func showUserData(){
        if let userdata = SingletonClass.sharedInstance.LoginRegisterUpdateData{
            txtFirstName.text = userdata.firstName ?? ""
            txtLastName.text = userdata.lastName ?? ""
            txtEmail.text = userdata.email ?? ""
            txtPhoneNumber.text = userdata.phone
        
            if let imageURL = userdata.profilePicture{
                imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgProfile.sd_setImage(with: URL(string: imageURL),  placeholderImage: UIImage(named: "default_user"))
            }
        }
    }
    func AlertSheet1(){
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { [self] action -> Void in
            self.camera()
            print("First Action pressed")
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Choose From Gallery", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                //imagePicker.delegate = self
                
                
                self.present(self.imageupload, animated: true, completion: nil)
            }
            print("Second Action pressed")
        }
        let thirdAction: UIAlertAction = UIAlertAction(title: "Remove Profile", style: .destructive) { [self] action -> Void in
            self.imgProfile.image = #imageLiteral(resourceName: "user.png")
            print("Second Action pressed")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        if imgProfile.image != #imageLiteral(resourceName: "dummyUser") {
            actionSheetController.addAction(thirdAction)
        }
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgProfile.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    open class CircularView: UIView {
        @IBInspectable open var hasSquareCornerRadius: Bool = false {
            didSet {
                update()
            }
        }
        
        @IBInspectable open override var cornerRadius: CGFloat {
            didSet {
                update()
            }
        }
        
        public var normalizedCornerRadius: CGFloat {
            return hasSquareCornerRadius ? bounds.height / 2 : cornerRadius
        }
        
        fileprivate func update() {
            
            layer.cornerRadius = bounds.height / 2
            layer.masksToBounds = true
        }
        override open func layoutSubviews() {
            super.layoutSubviews()
            update()
        }
    }
}

// MARK: - ImagePickerDelegate
extension EditProfileVC:ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag:Int) {
    }
}
