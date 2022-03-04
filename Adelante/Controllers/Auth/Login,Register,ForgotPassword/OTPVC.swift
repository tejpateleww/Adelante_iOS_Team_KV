//
//  OTPVC.swift
//  Adelante
//
//  Created by Nirav S on 02/03/22.
//  Copyright © 2022 EWW071. All rights reserved.
//

import UIKit


enum Direction { case left, right }
class OTPVC: BaseViewController,OTPTextFieldDelegate, UITextFieldDelegate {
   
    
    var isFromLogin = false
    var isFromRegister = false
    var isFromEditProfile = false
    var strOTP = ""
    
    var reqModelLogin = LoginReqModel()
    var textFieldsIndexes:[OTPTextField:Int] = [:]
    var verifyOTPClosour : (() -> ())?
    var timer = Timer()
    var customTabBarController: CustomTabBarVC?
    
    var strfirst = ""
    var strLast = ""
    var strEmail = ""
    var strphoneNo = ""
    var strPassword = ""
//    var strType = ""
    var strtime = 31
    var selectedImage : UIImage?
    var isRemovePhoto = false
    
    
    @IBOutlet var txtOtpOutletCollection: [OTPTextField]!
    @IBOutlet weak var txtCode1: OTPTextField!
    @IBOutlet weak var txtCode2: OTPTextField!
    @IBOutlet weak var txtCode3: OTPTextField!
    @IBOutlet weak var txtCode4: OTPTextField!
    @IBOutlet weak var txtCode5: OTPTextField!
    @IBOutlet weak var txtCode6: OTPTextField!
    
    @IBOutlet weak var btnResendOtp: btnOTP!
    @IBOutlet weak var btnVerify: OtpButton!
    @IBOutlet weak var lblCount: themeLabel!
    
    @IBOutlet weak var lblVerify: themeLabel!
    @IBOutlet weak var lblCodeInstruction: themeLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        setUpLocalizedStrings()
    }
    
    
    func setUp() {
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarInViewController(controller: self, naviColor: colors.appGreenColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        
        for index in 0 ..< txtOtpOutletCollection.count {
            textFieldsIndexes[txtOtpOutletCollection[index]] = index
        }
        
        txtCode1.delegate = self
        txtCode2.delegate = self
        txtCode3.delegate = self
        txtCode4.delegate = self
        txtCode5.delegate = self
        txtCode6.delegate = self

        txtOtpOutletCollection[0].myDelegate = self
        txtOtpOutletCollection[1].myDelegate = self
        txtOtpOutletCollection[2].myDelegate = self
        txtOtpOutletCollection[3].myDelegate = self
        txtOtpOutletCollection[4].myDelegate = self
        txtOtpOutletCollection[5].myDelegate = self
        
        if isFromLogin == false && isFromRegister == true {
            self.webserviceForSendOTP(type: "0")
        }else if isFromLogin == false && isFromRegister == false && isFromEditProfile == true {
            self.webserviceForSendOTP(type: "1")
        }
    }
    func setUpLocalizedStrings() {
        lblVerify.text = "verify_lblVerify".Localized()
        lblCodeInstruction.text = "verify_lblCodeInstruction".Localized()
        btnVerify.setTitle("verify_btnVerify".Localized(), for: .normal)
    }
    
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
        } else if isFromLogin == false && isFromRegister == true {
            self.clearAllFields()
            self.strtime = 31
            self.reversetimer()
            self.webserviceForSendOTP(type: "0")
        }else if isFromLogin == false && isFromRegister == false && isFromEditProfile == true {
            self.clearAllFields()
            self.strtime = 31
            self.reversetimer()
            self.webserviceForSendOTP(type: "1")
        }
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
    
    
    func validation() -> Bool {
        //        let strEnteredOTP = "\(txtCode1.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")\(txtCode2.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")\(txtCode3.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")\(txtCode4.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")"
        var strEnteredOTP = ""
        for index in 0 ..< txtOtpOutletCollection.count {
            strEnteredOTP.append(txtOtpOutletCollection[index].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        }
        
        if strEnteredOTP == "" {
            Utilities.ShowAlert(OfMessage: "validMsg_RequiredOtp".Localized())
            return false
        }else if !self.timer.isValid{
            self.clearAllFields()
            Utilities.ShowAlert(OfMessage: "Your OTP has been expired")
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
    
    
    
    
    func textFieldDidDelete(currentTextField: OTPTextField) {
        print("delete")
        setNextResponder(textFieldsIndexes[currentTextField], direction: .left)
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        //        if textField != txtCode1 {
        setNextResponderBlank(textFieldsIndexes[textField as! OTPTextField])
        //        }
    }
    
    func reversetimer(){
        self.timer.invalidate() // just in case this button is tapped multiple times
//        self.lblCount.isHidden = false
//        self.btnResendOtp.isHidden = true
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    @objc func timerAction() {
        if self.strtime > 0{
            self.strtime -= 1
            self.lblCount.text =  "Resend after \(self.strtime > 9 ? "00:\(self.strtime)" : "00:0\(self.strtime)")  seconds"
        } else {
            self.btnResendOtp.isHidden = false
            self.lblCount.isHidden = true
            self.btnResendOtp.isUserInteractionEnabled = true
            btnResendOtp.setTitle("verify_btnResendOtp".Localized(), for: .normal)
            self.btnResendOtp.setTitleColor(colors.appOrangeColor.value, for: .normal)
            self.btnResendOtp.titleLabel?.font = CustomFont.AileronBold.returnFont(15)
            self.btnResendOtp.setunderline(title: "verify_btnResendOtp".Localized(), color: colors.appOrangeColor, font: CustomFont.AileronBold.returnFont(15))
            self.timer.invalidate()
        }
    }
    
    func webserviceForSendOTP(type : String)
    {
        let otp = sendOtpReqModel()
        otp.email = strEmail
        otp.phone = strphoneNo
        otp.type = type
        
       // self.showHUD()
        WebServiceSubClass.sendOTP(optModel: otp, showHud: true) { [self] (json, status, response) in
            self.hideHUD()
            if(status){
                let otpModel = otpReceive.init(fromJson: json)
                Utilities.showAlertOfAPIResponse(param: otpModel.code ?? "-", vc: self)
                print(json)
                reversetimer()
//                strtime = 30
//                lblCount.isHidden = false
//                lblCount.text = "\(strtime)"
//                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
//                    self?.setCalculationLs()
//                }
//                viewResendOTP.isHidden = true
                strOTP = otpModel.code
            }else {
                if let strMessage = json["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        }
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
        updateModel.phone = StrPhone
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
                Utilities.displayAlert("", message: response["message"].string ?? "", completion: {_ in
                    appDel.SetLogout()
                }, otherTitles: nil)
            }else{
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
        })
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
            WebServiceSubClass.register(registerModel: register,showHud: true, completion: { (json, status, response) in
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
                        appDel.navigateToMainLogin()
                        appDel.clearData()
                    }, otherTitles: nil)
                }
                else
                {
                    if let strMessage = json["message"].string {
                        Utilities.displayAlert(strMessage)
                    }else {
                        Utilities.displayAlert("", message: json["message"].string ?? "MessageNoIntenet".Localized(), completion: {_ in
                            self.navigationController?.popViewController(animated: true)
                        }, otherTitles: nil)
                    }
                }
            })
        }
}
