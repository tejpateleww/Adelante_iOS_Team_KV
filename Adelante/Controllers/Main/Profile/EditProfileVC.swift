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
        setUpLocalizedStrings()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: true)
        showUserData()
    
        setUp()
    }
    
    // MARK: - Other Methods
    func setUp() {
        txtFirstName.delegate = self
        txtLastName.delegate = self
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.editProfile.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        txtEmail.isUserInteractionEnabled = false
        lblVerified.textColor = colors.appGreenColor.value
        lblUnverified.textColor = colors.appGreenColor.value
    }
    
    func showUserData(){
        if let userdata = SingletonClass.sharedInstance.LoginRegisterUpdateData{
            txtFirstName.text = userdata.firstName ?? ""
            txtLastName.text = userdata.lastName ?? ""
            txtEmail.text = userdata.email ?? ""
            txtPhoneNumber.text = userdata.phone
            if SingletonClass.sharedInstance.LoginRegisterUpdateData?.profilePicture != ""{
                let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(userdata.profilePicture ?? "")"
                imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgProfile.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                selectedImage = imgProfile.image
            }else{
                imgProfile.image = UIImage.init(named: "Default_user")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // MARK: - IBActions
    @IBAction func btnProfilePicTap(_ sender: UIButton)
    {
        resignFirstResponder()
        if (self.imgProfile.image != nil || self.selectedImage != nil) && ((self.imgProfile.image?.isEqualToImage(UIImage.init(named: "Default_user")!)) != nil){
            self.imagePicker.present(from: self.imgProfile, viewPresented: self.view, isRemove: true)
        } else {
            self.imagePicker.present(from: self.imgProfile, viewPresented: self.view, isRemove: false)
        }
    }
    
    @IBAction func Btnsave(_ sender: Any) {
        if !txtFirstName.isEnabled{
            (sender as AnyObject).setImage(#imageLiteral(resourceName: "imgUpdateDone"), for: .normal)
        }else{
            if validation(){
                if let userdata = SingletonClass.sharedInstance.LoginRegisterUpdateData{
                    if userdata.email != txtEmail.text {
                        Utilities.displayAlert("", message:"EditProfileVC_EmailChange".Localized(), completion: { [self]_ in
                            webserviceForEditprofile()
                        }, otherTitles: nil)
                    }else if userdata.phone != txtPhoneNumber.text {
                        Utilities.displayAlert("", message: "EditProfileVC_PhoneChange".Localized(), completion: { [self]_ in
                            self.webserviceForSendOTP()
                        }, otherTitles: nil)
                    }else{
                        webserviceForEditprofile()
                    }
                }else{
                    webserviceForEditprofile()
                }
            }
        }
    }
    
    func validation()->Bool{
        let txtTemp = UITextField()
        txtTemp.text = txtFirstName.text?.replacingOccurrences(of: " ", with: "")
        let firstName = txtTemp.validatedText(validationType: ValidatorType.username(field: "first name") )//ValidatorType.requiredField(field: "first name"))
        txtTemp.text = txtLastName.text?.replacingOccurrences(of: " ", with: "")
        let lastname =  txtTemp.validatedText(validationType: ValidatorType.username(field: "last name"))
        
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
        lblUnverified.text = "EditProfileVC_lblVerified".Localized()
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
        if self.isRemovePhoto{
            updateModel.remove_image = "1"
        }
        WebServiceSubClass.UpdateProfileInfo(editProfileModel: updateModel, img: selectedImage ?? UIImage(), isRemoveImage: self.isRemovePhoto , showHud: true, completion: { (response, status, error) in
            if status{
                let updatedData = Userinfo.init(fromJson: response)
                SingletonClass.sharedInstance.LoginRegisterUpdateData = updatedData.profile
                userDefault.setUserData(objProfile: updatedData.profile)
                self.isRemovePhoto = false
                Utilities.displayAlert("", message: response["message"].string ?? "", completion: { [self]_ in
                    if updatedData.profile == nil {
                        appDel.SetLogout()
                    }else{
                        self.navigationController?.popViewController(animated: true)
                        self.delegateEdit.refereshProfileScreen()
                    }
                }, otherTitles: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    
    //OTP SEND API CALL
    func webserviceForSendOTP()
    {
        let otp = sendOtpReqModel()
        otp.user_name = txtEmail.text ?? ""
        
       // self.showHUD()
        WebServiceSubClass.sendOTP(optModel: otp, showHud: true) { [self] (json, status, response) in
            self.hideHUD()
            if(status){
                print(json)
                let otpModel = otpReceive.init(fromJson: json)
                let OTPVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: VerifyVC.storyboardID) as! VerifyVC
                OTPVC.isFromEditProfile = true
                OTPVC.strfirst = self.txtFirstName.text!
                OTPVC.strLast = self.txtLastName.text!
                OTPVC.strEmail = self.txtEmail.text!
                OTPVC.strphoneNo = self.txtPhoneNumber.text!
                OTPVC.strOTP = otpModel.code
                OTPVC.isRemovePhoto = isRemovePhoto
                OTPVC.selectedImage = selectedImage
                self.navigationController?.pushViewController(OTPVC, animated: true)
            }else {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        }
    }
}




// MARK: - ImagePickerDelegate
extension EditProfileVC:ImagePickerDelegate {
    
    func didSelect(image: UIImage?, SelectedTag:Int) {

            if(image == nil && SelectedTag == 101){
                self.selectedImage = UIImage()
                self.isRemovePhoto = true
                self.imgProfile.image = UIImage.init(named: "Default_user")
            }else if image != nil{
                DispatchQueue.main.async {
                    let fixedOrientedImage = image?.fixOrientation()
                   self.imgProfile.image = fixedOrientedImage
                    self.imgProfile.setNeedsDisplay()
                    self.selectedImage = fixedOrientedImage
                }
                self.isRemovePhoto = false
                self.imgProfile.layoutSubviews()
                self.imgProfile.layoutIfNeeded()
            }else{
                return
            }
    }
}

//extension EditProfileVC:ImagePickerDelegate {
//
//    func didSelect(image: UIImage?, SelectedTag:Int) {
//        //        isRemovePhoto = false
//        if(image == nil && SelectedTag == 101){
//            self.selectedImage = UIImage()
//            self.isRemovePhoto = true
//            self.imgProfile.image = UIImage.init(named: "Default_user")
//            //webservice_RemoveProfilePicture()
//        }else if image != nil{
//            let fixedOrientedImage = image?.fixOrientation()
//            self.imgProfile.image = fixedOrientedImage
//            self.selectedImage = self.imgProfile.image
//        }else{
//            return
//        }
//    }
//}
extension EditProfileVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if newString.hasPrefix(" "){
            textField.text = ""
            return false
        }else if textField == txtFirstName || textField == txtLastName {
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtPhoneNumber{
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
