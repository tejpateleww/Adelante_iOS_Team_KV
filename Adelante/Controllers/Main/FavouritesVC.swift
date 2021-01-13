//
//  FavouritesVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class FavouritesVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrFavorite = [Favorite]()
    var arrRestaurant = [RestaurantFav]()
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var txtSearch: customTextField!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        setup()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
        
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.favourites.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearch.frame.height))
        txtSearch.leftView = padding
        txtSearch.leftViewMode = UITextField.ViewMode.always
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
    }
    func setUpLocalizedStrings() {
        txtSearch.placeholder = "FavouritesVC_txtSearch".Localized()
    }
    // MARK: - IBActions
    
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainList.dequeueReusableCell(withIdentifier: YourFavouriteCell.reuseIdentifier, for: indexPath) as! YourFavouriteCell
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID)
            self.navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - Api Calls
    func webservicePostRestaurantFav(strSearch : String){
        let RestaurantFavorite = RestaurantFavoriteReqModel()
        RestaurantFavorite.restaurant_id = strSearch
        RestaurantFavorite.user_id = strSearch
        RestaurantFavorite.page = strSearch
        WebServiceSubClass.RestaurantFavorite(RestaurantFavoritemodel: RestaurantFavorite, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let restaurantData = RestaurantListResModel.init(fromJson: response)
//                self.arrRestaurantList = restaurantData.data
                self.tblMainList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
}
