//
//  EditProfileVC.swift
//  Adelante
//
//  Created by baps on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

protocol EditProfileDelegate {
    func refereshProfileScreen()
}

class EditProfileVC: BaseViewController{
    
    // MARK: - Properties
    var delegateEdit : EditProfileDelegate!
    var selectedImage : UIImage?
    var customTabBarController: CustomTabBarVC?
    private var imagePicker : ImagePicker!
    var isRemovePhoto = false
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
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: false)
        showUserData()
        setUpLocalizedStrings()
        setUp()
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.editProfile.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
      
    }
    
    func showUserData(){
        if let userdata = SingletonClass.sharedInstance.LoginRegisterUpdateData{
            txtFirstName.text = userdata.firstName ?? ""
            txtLastName.text = userdata.lastName ?? ""
            txtEmail.text = userdata.email ?? ""
            txtPhoneNumber.text = userdata.phone

            let strUrl = "\(APIEnvironment.profileBu.rawValue)\(userdata.profilePicture ?? "")"
                imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgProfile.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage(named: "Default_user"))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
           self.customTabBarController?.hideTabBar()
       }
    // MARK: - IBActions
    @IBAction func btnProfilePicTap(_ sender: UIButton)
    {
        resignFirstResponder()
        self.imagePicker.present(from: self.imgProfile, viewPresented: self.view)
    }
    
    @IBAction func Btnsave(_ sender: Any) {
        if !txtFirstName.isEnabled{
            (sender as AnyObject).setImage(#imageLiteral(resourceName: "imgUpdateDone"), for: .normal)
        }else{
            if validation(){
                webserviceForEditprofile()
            }
        }
//        self.navigationController?.popViewController(animated: true)
    }
    func validation()->Bool{
        let firstName = txtFirstName.validatedText(validationType: ValidatorType.username(field: "first name") )//ValidatorType.requiredField(field: "first name"))
        let lastname =  txtLastName.validatedText(validationType: ValidatorType.username(field: "last name"))
        
        let phone = txtPhoneNumber.validatedText(validationType: ValidatorType.requiredField(field: "contact number"))
        
        if (!firstName.0){
            Utilities.ShowAlert(OfMessage: firstName.1)
            return firstName.0
        }else if (!lastname.0){
            Utilities.ShowAlert(OfMessage: lastname.1)
            return lastname.0
        }
        else if (!phone.0){
            Utilities.ShowAlert(OfMessage: phone.1)
            return phone.0
        }
        
        return true
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
        let updateModel = EditProfileReqModel()
        var StrPhone = txtPhoneNumber.text?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: " ", with: "")
        StrPhone = StrPhone?.replacingOccurrences(of: ")", with: "")
        StrPhone = StrPhone?.replacingOccurrences(of: "-", with: "")
        updateModel.email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updateModel.first_name = txtFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updateModel.last_name = txtLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updateModel.phone = StrPhone! //txtPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updateModel.user_id = SingletonClass.sharedInstance.UserId
        self.showHUD()
        WebServiceSubClass.UpdateProfileInfo(editProfileModel: updateModel, img: selectedImage ?? UIImage() , showHud: true, completion: { (response, status, error) in
            self.hideHUD()
            if status{
                let updatedData = Userinfo.init(fromJson: response)
                SingletonClass.sharedInstance.LoginRegisterUpdateData = updatedData.profile
                userDefault.setUserData(objProfile: updatedData.profile)
                Utilities.displayAlert("", message: response["message"].string ?? "", completion: {_ in
                self.navigationController?.popViewController(animated: true)
                self.delegateEdit.refereshProfileScreen()
                }, otherTitles: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    }

// MARK: - ImagePickerDelegate
extension EditProfileVC:ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag:Int) {
        isRemovePhoto = false
            if(image == nil && SelectedTag == 101){
               
                //webservice_RemoveProfilePicture()
            }else if image != nil{
                let fixedOrientedImage = image?.fixOrientation()
               self.imgProfile.image = fixedOrientedImage
                self.selectedImage = self.imgProfile.image
            }else{
                return
            }
    }
}
