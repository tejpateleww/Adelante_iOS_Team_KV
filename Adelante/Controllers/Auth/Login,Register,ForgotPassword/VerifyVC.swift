//
//  VerifyVC.swift
//  Adelante
//
//  Created by iMac on 6/17/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import UIKit

enum Direction { case left, right }

class VerifyVC: BaseViewController,UITextFieldDelegate, OTPTextFieldDelegate {

    // MARK: - Properties
    var isFromLogin = false
    var isFromRegister = false
    var isFromEditProfile = false
    var strOTP = ""
    
    var reqModelLogin = LoginReqModel()
    var textFieldsIndexes:[OTPTextField:Int] = [:]
    var verifyOTPClosour : (() -> ())?
    weak var timer: Timer?
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblVerify: themeLabel!
    @IBOutlet weak var lblCodeInstruction: themeLabel!
    @IBOutlet weak var txtCode1: OTPTextField!
    @IBOutlet weak var txtCode2: OTPTextField!
    @IBOutlet weak var txtCode4: OTPTextField!
    @IBOutlet weak var txtCode3: OTPTextField!
    @IBOutlet weak var btnResendOtp: btnOTP!
    @IBOutlet weak var btnVerify: OtpButton!
    @IBOutlet weak var btnDontRecOtp: btnOTP!
    @IBOutlet var txtOtpOutletCollection: [OTPTextField]!
    
    @IBOutlet weak var lblCount: themeLabel!
    @IBOutlet weak var viewResendOTP: UIStackView!
    
    var strfirst = ""
    var strLast = ""
    var strEmail = ""
    var strphoneNo = ""
    var strPassword = ""
    var strtime = 30
    var selectedImage : UIImage?
    var isRemovePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        setUpLocalizedStrings()
        setUpDetails()
        
        for index in 0 ..< txtOtpOutletCollection.count {
            textFieldsIndexes[txtOtpOutletCollection[index]] = index
        }
        txtOtpOutletCollection[0].myDelegate = self
        txtOtpOutletCollection[1].myDelegate = self
        txtOtpOutletCollection[2].myDelegate = self
        txtOtpOutletCollection[3].myDelegate = self
        txtOtpOutletCollection[4].myDelegate = self
        txtOtpOutletCollection[5].myDelegate = self
        lblCount.isHidden = false
        lblCount.text = "\(strtime)"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.setCalculationLs()
        }
        viewResendOTP.isHidden = true
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func setCalculationLs() {
        strtime = strtime - 1
        lblCount.text = "\(strtime)"
        print(strtime)
        if strtime == 0{
            lblCount.isHidden = true
            viewResendOTP.isHidden = false
            timer?.invalidate()
        }
    }
    
    
    func setUpLocalizedStrings() {
        lblVerify.text = "verify_lblVerify".Localized()
        lblCodeInstruction.text = "verify_lblCodeInstruction".Localized()
        btnDontRecOtp.setTitle("verify_btnDontRecOtp".Localized(), for: .normal)
        btnResendOtp.setTitle("verify_btnResendOtp".Localized(), for: .normal)
        btnVerify.setTitle("verify_btnVerify".Localized(), for: .normal)
    }
    
    func setUpDetails() {
    }
    
    func navigateToVerifyScreen(strOTP: String, reqLogin: LoginReqModel) {
        let verifyVC = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: VerifyVC.storyboardID) as! VerifyVC
        verifyVC.strOTP = strOTP
        verifyVC.isFromLogin = true
        verifyVC.isFromRegister = false
        verifyVC.reqModelLogin = reqLogin
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    
    func setNextResponder(_ index:Int?, direction:Direction) {
        guard let index = index else { return }
        
        if direction == .left {
            index == 0 ?
                (_ = txtOtpOutletCollection.first?.resignFirstResponder()) :
                (_ = txtOtpOutletCollection[(index - 1)].becomeFirstResponder())
            if index > 0 {
                let neIndex = index + 1
                for i in neIndex..<txtOtpOutletCollection.count {
                    txtOtpOutletCollection[i].text = ""
                }
                
                //                let prevIndex = index - 1
                //                for i in 0..<prevIndex {
                //                    txtOtpOutletCollection[i].isUserInteractionEnabled = false
                //                }
            }
        } else {
            index == txtOtpOutletCollection.count - 1 ?
                (_ = txtOtpOutletCollection.last?.resignFirstResponder()) :
                (_ = txtOtpOutletCollection[(index + 1)].becomeFirstResponder())
        }
    }
    
    func setNextResponderBlank(_ index:Int?) {
        if index! >= 0 {
            let neIndex = index! + 1
            for i in neIndex..<txtOtpOutletCollection.count {
                txtOtpOutletCollection[i].text = ""
            }
        }
    }
    
    // MARK: - Other Methods
    func setUp() {
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarInViewController(controller: self, naviColor: colors.appGreenColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        Utilities.showAlertOfAPIResponse(param: strOTP, vc: self)
    }
    
    func validation() -> Bool {
        //        let strEnteredOTP = "\(txtCode1.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")\(txtCode2.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")\(txtCode3.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")\(txtCode4.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")"
        var strEnteredOTP = ""
        for index in 0 ..< txtOtpOutletCollection.count {
            strEnteredOTP.append(txtOtpOutletCollection[index].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        }
        
        if strEnteredOTP == "" {
            Utilities.ShowAlert(OfMessage: "validMsg_RequiredOtp".Localized())
            return false
        } else if self.strOTP != strEnteredOTP {
            self.clearAllFields()
            Utilities.ShowAlert(OfMessage: "validMsg_InvalidOtp".Localized())
            return false
        }
        return true
    }
    
    func clearAllFields() {
        for index in 0 ..< txtOtpOutletCollection.count {
            txtOtpOutletCollection[index].text = ""
        }
    }
    
    // MARK: - IBActions
    @IBAction func btnVerifyClicked(_ sender: UIButton) {
        if validation() {
            if isFromLogin == true && isFromRegister == false {
               // self.webserviceForLogin()
            } else if isFromLogin == false && isFromRegister == true {
                webserviceForRegister()
            } else if isFromLogin == false && isFromRegister == false && isFromEditProfile == true {
                webserviceForEditprofile()
            }
        }
    }
    
    @IBAction func btnResendOtp(_ sender: UIButton) {
        if isFromLogin == true && isFromRegister == false {
            self.clearAllFields()
//            self.webserviceForSendOTP()
        } else if isFromLogin == false && isFromRegister == true {
            self.clearAllFields()
            self.webserviceForSendOTP()
        }else if isFromLogin == false && isFromRegister == false && isFromEditProfile == true {
            self.clearAllFields()
            self.webserviceForSendOTP()
        }
    }
    
    // MARK: - UITextFieldDelegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 {
            setNextResponder(textFieldsIndexes[textField as! OTPTextField], direction: .right)
            textField.text = string
            return true
        } else if range.length == 1 {
            setNextResponder(textFieldsIndexes[textField as! OTPTextField], direction: .left)
            
            textField.text = ""
            return false
        }
        return false
    }
    
    // MARK: - OTPTextFieldDelegate
    func textFieldDidDelete(currentTextField: OTPTextField) {
        print("delete")
        setNextResponder(textFieldsIndexes[currentTextField], direction: .left)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        //        if textField != txtCode1 {
        setNextResponderBlank(textFieldsIndexes[textField as! OTPTextField])
        //        }
    }
    
//    // MARK: - API Calls
    
    func webserviceForRegister()
    {
        let register = RegisterReqModel()
        register.first_name = strfirst.trimmingCharacters(in: .whitespacesAndNewlines)
        register.last_name = strLast.trimmingCharacters(in: .whitespacesAndNewlines)
        register.email = strEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        register.phone = strphoneNo
        register.password = strPassword
        register.device_token = SingletonClass.sharedInstance.DeviceToken
        register.device_type = ReqDeviceType
        register.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        register.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.register(registerModel: register,showHud: false, completion: { (json, status, response) in
            if(status)
            {
                print(json)
                let loginModel = Userinfo.init(fromJson: json)
                let registerRespoDetails = loginModel.profile
                Utilities.displayAlert("", message: loginModel.message ?? "MessageNoIntenet".Localized(),vc: self, completion: {_ in
                    SingletonClass.sharedInstance.UserId = registerRespoDetails?.id ?? ""
                    SingletonClass.sharedInstance.Api_Key = registerRespoDetails?.apiKey ?? ""
                    SingletonClass.sharedInstance.LoginRegisterUpdateData = registerRespoDetails
                    userDefault.setValue(registerRespoDetails?.apiKey , forKey: UserDefaultsKey.X_API_KEY.rawValue)
                    userDefault.setValue(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                    userDefault.setUserData(objProfile: registerRespoDetails!)
                    appDel.navigateToLogin()
                    appDel.clearData()
                }, otherTitles: nil)
            }
            else
            {
                Utilities.displayAlert("", message: json["message"].string ?? "MessageNoIntenet".Localized(), completion: {_ in
                    self.navigationController?.popViewController(animated: true)
                }, otherTitles: nil)
                //displayErrorAlert(json["message"].string ?? "MessageNoIntenet".Localized())
            }
        })
    }
    
    func webserviceForEditprofile()
    {
        let updateModel = EditProfileReqModel()
        var StrPhone = strphoneNo.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: " ", with: "")
        StrPhone = StrPhone.replacingOccurrences(of: ")", with: "")
        StrPhone = StrPhone.replacingOccurrences(of: "-", with: "")
        updateModel.email = strEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        updateModel.first_name = strfirst.trimmingCharacters(in: .whitespacesAndNewlines)
        updateModel.last_name = strLast.trimmingCharacters(in: .whitespacesAndNewlines)
        updateModel.phone = StrPhone //txtPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        updateModel.user_id = SingletonClass.sharedInstance.UserId
        if self.isRemovePhoto{
            updateModel.remove_image = "1"
        }
        WebServiceSubClass.UpdateProfileInfo(editProfileModel: updateModel, img: selectedImage ?? UIImage(), isRemoveImage: self.isRemovePhoto , showHud: false, completion: { (response, status, error) in
            if status{
                let updatedData = Userinfo.init(fromJson: response)
                SingletonClass.sharedInstance.LoginRegisterUpdateData = updatedData.profile
                userDefault.setUserData(objProfile: updatedData.profile)
                self.isRemovePhoto = false
                Utilities.displayAlert("", message: response["message"].string ?? "", completion: {_ in
                    appDel.SetLogout()
                }, otherTitles: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func webserviceForSendOTP()
    {
        let otp = sendOtpReqModel()
        otp.email = strEmail
        otp.phone = strphoneNo
        if isFromRegister == true{
            otp.type = "0"
        }else{
            otp.type = "1"
        }
        
       // self.showHUD()
        WebServiceSubClass.sendOTP(optModel: otp, showHud: false) { [self] (json, status, response) in
            self.hideHUD()
            if(status){
                let otpModel = otpReceive.init(fromJson: json)
                Utilities.showAlertOfAPIResponse(param: otpModel.code, vc: self)
                print(json)
                strOTP = otpModel.code
            }else {
                Utilities.displayErrorAlert(json["message"].string ?? "Something went wrong")
            }
        }
    }
}

