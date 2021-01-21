//
//  RestaurantListVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,FavoriteUpdateDelegate {
    func refreshRestaurantFavorite() {
        webwerviceFavorite(strRestaurantId: "", Status: "")
    }
    
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrRestaurantList = [RestaurantList]()
    private var lastSearchTxt = ""
    var refreshList = UIRefreshControl()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var btnFilterOptions: UIButton!
    @IBOutlet weak var lblAllRestaurants: themeLabel!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
//        tblMainList.refreshControl = refreshList
//        refreshList.addTarget(self, action: #selector(webserviceGetRestaurantList(strSearch:strFilter:)), for: .valueChanged)
        setUpLocalizedStrings()
        webserviceGetRestaurantList(strSearch: "", strFilter: "")
        
        let button = UIButton()
//        button.backgroundColor = .green
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.restaurantList.value, leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deselectFilterOptionRest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deSelectFilterAndRefresh), name: NSNotification.Name(rawValue: "deselectFilterOptionRest"), object: nil)
        
        btnFilterOptions.isSelected = false
        self.changeLayoutOfFilterButton()
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
    }
    func setUpLocalizedStrings(){
        txtSearch.placeholder = "RestaurantListVC_txtSearch".Localized()
        lblAllRestaurants.text = "RestaurantListVC_lblAllRestaurants".Localized()
    }
    @objc func deSelectFilterAndRefresh() {
        btnFilterOptions.isSelected = false
        changeLayoutOfFilterButton()
    }
    
    func changeLayoutOfFilterButton() {
        if btnFilterOptions.isSelected {
            btnFilterOptions.backgroundColor = colors.segmentSelectedColor.value
        } else {
            btnFilterOptions.backgroundColor = colors.segmentDeselectedColor.value
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - IBActions
    @IBAction func buttonTapFavorite(_ sender: UIButton) {
        var Select = arrRestaurantList[sender.tag].favourite ?? ""
        let restaurantId = arrRestaurantList[sender.tag].id ?? ""
        if Select == "1"{
            Select = "0"
        }else{
            Select = "1"
        }
        webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
    }
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.changeLayoutOfFilterButton()
        } else {
            sender.isSelected = true
            self.changeLayoutOfFilterButton()
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: sortPopupVC.storyboardID)
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRestaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantListCell.reuseIdentifier, for: indexPath) as! RestaurantListCell
        cell.lblName.text = arrRestaurantList[indexPath.row].name
        cell.lblRating.text = arrRestaurantList[indexPath.row].review
        cell.lblMiles.text = String(format: "HomeVC_RestaurantCell_lblMiles".Localized(), arrRestaurantList[indexPath.row].distance)
        let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrRestaurantList[indexPath.row].image ?? "")"
        cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
        if arrRestaurantList[indexPath.row].favourite == "1"{
            cell.btnFavorite.isSelected = true
        }else{
            cell.btnFavorite.isSelected = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restDetailsVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID)
        self.navigationController?.pushViewController(restDetailsVc, animated: true)
    }
    
    // MARK: - Api Calls
    @objc func webserviceGetRestaurantList(strSearch:String,strFilter:String){
        let RestaurantList = RestaurantListReqModel()
        RestaurantList.user_id = SingletonClass.sharedInstance.UserId
        RestaurantList.filter = strFilter
        RestaurantList.item = strSearch
        RestaurantList.page = "1"
        RestaurantList.item_id = ""
        RestaurantList.item_type = ""
        WebServiceSubClass.RestaurantList(RestaurantListmodel: RestaurantList, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let restaurantData = RestaurantListResModel.init(fromJson: response)
                self.arrRestaurantList = restaurantData.data
                self.tblMainList.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
            DispatchQueue.main.async {
                self.refreshList.endRefreshing()
            }
        })
    }
    func webwerviceFavorite(strRestaurantId:String,Status:String){
        let favorite = FavoriteReqModel()
        favorite.restaurant_id = strRestaurantId
        favorite.status = Status
        favorite.user_id = SingletonClass.sharedInstance.UserId
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: false, completion: { (response, status, error) in
//            self.hideHUD()
            if status{
                self.webserviceGetRestaurantList(strSearch: "", strFilter: "")
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
}
extension RestaurantListVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if lastSearchTxt.isEmpty {
            lastSearchTxt = searchText
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall), object: lastSearchTxt)
        lastSearchTxt = searchText
        self.perform(#selector(self.makeNetworkCall), with: searchText, afterDelay: 0.7)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        txtSearch.resignFirstResponder()
    }
    @objc private func makeNetworkCall(_ query: String)
    {
        webserviceGetRestaurantList(strSearch: query, strFilter: "")
    }
}
