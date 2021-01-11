//
//  RestaurantListVC.swift
//  Adelante
//
//  Created by apple on 07/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrRestaurantList = [RestaurantList]()
    private var lastSearchTxt = ""
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var btnFilterOptions: UIButton!
    @IBOutlet weak var lblAllRestaurants: themeLabel!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        setUpLocalizedStrings()
        webserviceGetRestaurantList(strSearch: "", strFilter: "")
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restDetailsVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID)
        self.navigationController?.pushViewController(restDetailsVc, animated: true)
    }
    
    // MARK: - Api Calls
    func webserviceGetRestaurantList(strSearch:String,strFilter:String){
        let RestaurantList = RestaurantListReqModel()
        RestaurantList.filter = strFilter
        RestaurantList.item = strSearch
        RestaurantList.page = strSearch
        WebServiceSubClass.RestaurantList(RestaurantListmodel: RestaurantList, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let restaurantData = RestaurantListResModel.init(fromJson: response)
                self.arrRestaurantList = restaurantData.data
                self.tblMainList.reloadData()
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
