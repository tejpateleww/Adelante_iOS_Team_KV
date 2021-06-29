//
//  MyProfileVC.swift
//  Adelante
//
//  Created by baps on 01/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
class MyProfileVC: BaseViewController,EditProfileDelegate {
   
    

    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var loginModelDetails : Profile?
    // MARK: - IBOutlets
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var btnEditAccount: submitButton!
    @IBOutlet weak var txtEmail: floatTextField!
    @IBOutlet weak var txtPhoneNumber: floatTextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webserviceGetProfile()
        setUpLocalizedStrings()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // MARK: - Other Methods
    func setUp() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.myProfile.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
    }
    
    func setupUserDetails(){
        txtEmail.text = loginModelDetails?.email
        txtPhoneNumber.text = loginModelDetails?.phone
        lblName.text = loginModelDetails?.fullName
        let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(loginModelDetails?.profilePicture ?? "")"
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgProfile.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage(named: "Default_user"))
        
    }
    func setUpLocalizedStrings() {
        btnEditAccount.setTitle("MyProfileVC_btnEditAccount".Localized(), for: .normal)
        txtEmail.placeholder = "MyProfileVC_txtEmail".Localized()
        txtPhoneNumber.placeholder = "MyProfileVC_txtPhoneNumber".Localized()
    }
    // MARK: - IBActions
    
    @IBAction func BtnEditAccount(_ sender: Any) {
       let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: EditProfileVC.storyboardID) as! EditProfileVC
        controller.delegateEdit = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - Api Calls
    func webserviceGetProfile(){
        let strURL = APIEnvironment.baseURL + ApiKey.GetProfile.rawValue + "/" + SingletonClass.sharedInstance.UserId
        WebServiceSubClass.profile(strURL: strURL, showHud: true, completion: { (json, status, response) in
            if(status)
            {
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.isUserLogin.rawValue)
                let loginModel = Userinfo.init(fromJson: json)
                self.loginModelDetails = loginModel.profile
                userDefault.setUserData(objProfile: self.loginModelDetails!)
                SingletonClass.sharedInstance.LoginRegisterUpdateData = self.loginModelDetails
//                self.loginModelDetails.ApiKey =
                self.setupUserDetails()
            }
            else
            {
                Utilities.displayErrorAlert(json["message"].string ?? "No internet connection")
            }
        })
    }
    
    // MARK: - EditProfileDelegate
    func refereshProfileScreen() {
        webserviceGetProfile()
    }
}
