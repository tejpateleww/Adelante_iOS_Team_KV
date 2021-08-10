//
//  SearchVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import BetterSegmentedControl
import SkeletonView

class SearchVC: BaseViewController,UINavigationControllerDelegate, UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Properties
    var responseStatus : webserviceResponse = .initial
    var customTabBarController: CustomTabBarVC?
    var arrSearchRestList = [SearchRestaurant]()
    var arrSearchRestItemList = [SearchRestaurantItem]()
    private var lastSearchTxt = ""
    var refreshList = UIRefreshControl()
    var selectedSegmentTag = 0
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tblRestaurant: UITableView!
    @IBOutlet weak var tblFoodList: UITableView!
    // MARK: - ViewController Lifecycl
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        tblRestaurant.refreshControl = refreshList
        tblFoodList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        setUpLocalizedStrings()
        setup()
        tblRestaurant.isHidden = false
        tblFoodList.isHidden = true
        tblFoodList.tableFooterView = UIView()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
        if txtSearch.text!.isEmptyOrWhitespace(){
            self.tblRestaurant.setEmptyMessage("Search something")
            self.tblFoodList.setEmptyMessage("Search something")
        }
    }
    @objc func refreshFavList() {
        self.webserviceSearchModel(strSearch: "")
    }
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.SearchVC.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        tblRestaurant.delegate = self
        tblRestaurant.dataSource = self
        tblFoodList.delegate = self
        tblFoodList.dataSource = self
    }
    //MARK: - UITableview Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblRestaurant {
                    return self.arrSearchRestList.count
        }else{
                    return self.arrSearchRestItemList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblRestaurant {
                    let cell = tblRestaurant.dequeueReusableCell(withIdentifier: RestaurantOutletListCell.reuseIdentifier,for: indexPath) as! RestaurantOutletListCell
                    cell.lblAreaName.text = arrSearchRestList[indexPath.row].name
                    cell.lblAddress.text = arrSearchRestList[indexPath.row].address
                    cell.lblMiles.text = arrSearchRestList[indexPath.row].distance
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrSearchRestList[indexPath.row].image ?? "")"
                    cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.btnFavorite.tag = indexPath.row
                    cell.btnFavorite.addTarget(self, action: #selector(btnTapFavorite(_:)), for: .touchUpInside)
                    if arrSearchRestList[indexPath.row].favourite == "1"{
                        cell.btnFavorite.isSelected = true
                    }else{
                        cell.btnFavorite.isSelected = false
                    }
                    cell.selectionStyle = .none
                    return cell
        }else{
                    let cell:searchFoodLIstCell = tblFoodList.dequeueReusableCell(withIdentifier: "searchFoodLIstCell", for: indexPath) as! searchFoodLIstCell
                    cell.lblComboTitle.text = arrSearchRestItemList[indexPath.row].name
                    cell.lblPrice.text = (CurrencySymbol) + arrSearchRestItemList[indexPath.row].price
                    cell.lblDisc.text = arrSearchRestItemList[indexPath.row].descriptionField
                    let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrSearchRestItemList[indexPath.row].image ?? "")"
                    cell.imgFoodLIst.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
                    cell.lblRating.text = "\(arrSearchRestItemList[indexPath.row].ratingCount!)"
                    cell.lblRestaurant.text = arrSearchRestItemList[indexPath.row].restaurantName.trimmingCharacters(in: .whitespaces)
                    cell.lblMiles.text = arrSearchRestItemList[indexPath.row].distance
                    cell.selectionStyle = .none
                    
                    cell.decreaseData = {
                        var strQty = ""
                        if cell.lblNoOfItem.text != ""{
                            var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                            if value == 1{
                                cell.btnAdd.isHidden = false
                                cell.vwStapper.isHidden = true
                            }else if value > 1{
                                value = value - 1
                                cell.lblNoOfItem.text = String(value)
                                strQty = "\(value)"
                            }
                        }
                        self.arrSearchRestItemList[indexPath.row].quantity = strQty
                        var pr = 0
                        pr = strQty.toInt() * self.arrSearchRestItemList[indexPath.row].price.toInt()
                        let objItem = selectedOrderItems(restaurant_item_id: self.arrSearchRestItemList[indexPath.row].id, quantity: self.arrSearchRestItemList[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrSearchRestItemList[indexPath.row].name, originalPrice: self.arrSearchRestItemList[indexPath.row].price, size: self.arrSearchRestItemList[indexPath.row].size, selectedQuantity: strQty)
                        print(objItem)
                    }
                    cell.IncreseData = { [self] in
                        var value : Int = (cell.lblNoOfItem.text! as NSString).integerValue
                        if self.arrSearchRestItemList[indexPath.row].quantity.toInt() > value {
                            var strQty = ""
                            if cell.lblNoOfItem.text != ""{
                                
                                value = value + 1
                                cell.lblNoOfItem.text = String(value)
                                strQty = "\(value)"
                            }
                            self.arrSearchRestItemList[indexPath.row].quantity = strQty
                            var pr = 0
                            pr = strQty.toInt() * self.arrSearchRestItemList[indexPath.row].price.toInt()
                            let objItem = selectedOrderItems(restaurant_item_id: self.arrSearchRestItemList[indexPath.row].id, quantity: self.arrSearchRestItemList[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrSearchRestItemList[indexPath.row].name, originalPrice: self.arrSearchRestItemList[indexPath.row].price, size: self.arrSearchRestItemList[indexPath.row].size, selectedQuantity: strQty)
                            print(objItem)
                        }
                        else {
                            Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized()), vc: self)
                        }
                    }
                    cell.btnAddAction = {
                        if self.arrSearchRestItemList[indexPath.row].quantity.ToDouble() >= 1 {
                            cell.btnAdd.isHidden = true
                            cell.vwStapper.isHidden = false
                            let strQty = "1"
                            cell.lblNoOfItem.text = strQty
                            self.arrSearchRestItemList[indexPath.row].quantity = strQty
                            var pr = 0
                            pr = strQty.toInt() * self.arrSearchRestItemList[indexPath.row].price.toInt()
                            let objItem = selectedOrderItems(restaurant_item_id: self.arrSearchRestItemList[indexPath.row].id, quantity: self.arrSearchRestItemList[indexPath.row].quantity, price: "\(pr)", variants_id: [], name: self.arrSearchRestItemList[indexPath.row].name, originalPrice: self.arrSearchRestItemList[indexPath.row].price, size: self.arrSearchRestItemList[indexPath.row].size, selectedQuantity: strQty)
                            print(objItem)
                        }
                        else {
                            Utilities.showAlert(AppName, message: String(format: "MessageQtyNotAvailable".Localized()), vc: self)
                        }
                    }
                    return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblRestaurant {
            if arrSearchRestList[indexPath.row].type == "restaurant" {
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantOutletVC.storyboardID) as! RestaurantOutletVC
                controller.selectedRestaurantId = arrSearchRestList[indexPath.row].id
                controller.strRestaurantName = arrSearchRestList[indexPath.row].name
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
                controller.selectedRestaurantId = arrSearchRestList[indexPath.row].id
                controller.selectedIndex = "\(indexPath.row)"
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }else{
            if arrSearchRestItemList[indexPath.row].type == "restaurant" {
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantOutletVC.storyboardID) as! RestaurantOutletVC
                controller.selectedRestaurantId = arrSearchRestItemList[indexPath.row].id
                controller.strRestaurantName = arrSearchRestItemList[indexPath.row].name
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantDetailsVC.storyboardID) as! RestaurantDetailsVC
                controller.selectedRestaurantId = arrSearchRestItemList[indexPath.row].id
                controller.SearchData = arrSearchRestItemList[indexPath.row].itemId
                controller.selectedIndex = "\(indexPath.row)"
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    func setUpLocalizedStrings() {
        txtSearch.placeholder = "SearchVC_txtSearch".Localized()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func btnTapFavorite(_ sender: UIButton) {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
        }
    }
    
    @IBAction func segmentControlChanged(_ sender: BetterSegmentedControl) {
        selectedSegmentTag = sender.index
        if selectedSegmentTag == 0{
            print("restaurnt")
            tblRestaurant.isHidden = false
            tblFoodList.isHidden = true
            tblRestaurant.reloadData()
        }else{
            print("Food List")
            tblRestaurant.isHidden = true
            tblFoodList.isHidden = false
            tblFoodList.reloadData()
        }
    }
    
    // MARK: - Api Calls
    @objc func webserviceSearchModel(strSearch:String){
        let search = SearchReqModel()
        search.name = strSearch
        search.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        search.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        search.user_id = SingletonClass.sharedInstance.UserId
        search.page = "\(pageNumber)"

        WebServiceSubClass.search(Searchmodel: search, showHud: true, completion: { (response, status, error) in
            self.responseStatus = .gotData
            if status{
                let result = SearchResModel(fromJson: response)
                self.arrSearchRestList = result.data.restaurant
                self.arrSearchRestItemList = result.data.restaurantItem
                if self.txtSearch.text == ""{
                    self.tblRestaurant.setEmptyMessage("Search something")
                    self.tblFoodList.setEmptyMessage("Search something")
                }
                self.tblRestaurant.reloadData()
                self.tblFoodList.reloadData()
            }else{
                if let strMessage = response["message"].string {
                    Utilities.displayAlert(strMessage)
                }else {
                    Utilities.displayAlert("Something went wrong")
                }
            }
            if self.arrSearchRestList.count > 0{
                self.tblRestaurant.restore()
            }else {
                self.tblRestaurant.setEmptyMessage("No result found for \"\(self.txtSearch.text ?? "")\"")
            }
            if self.arrSearchRestItemList.count > 0{
                self.tblFoodList.restore()
            }else {
                self.tblFoodList.setEmptyMessage("No result found for \"\(self.txtSearch.text ?? "")\"")
            }
            DispatchQueue.main.async {
                self.refreshList.endRefreshing()
            }
        })
    }
}
extension SearchVC:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if lastSearchTxt.isEmpty{
            lastSearchTxt = searchText
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall(_:)), object: lastSearchTxt)
        lastSearchTxt = searchText
        self.perform(#selector(self.makeNetworkCall(_:)), with: searchText, afterDelay: 0.7)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        txtSearch.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if txtSearch.text == ""{
            self.tblRestaurant.setEmptyMessage("Search something")
            self.tblFoodList.setEmptyMessage("Search something")
        }
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        txtSearch.text = ""
        if txtSearch.text == ""{
            self.tblRestaurant.setEmptyMessage("Search something")
            self.tblFoodList.setEmptyMessage("Search something")
        }
    }
    @objc private func makeNetworkCall(_ query: String)
    {
        if query == ""{
            if txtSearch.text == ""{
                self.tblRestaurant.setEmptyMessage("Search something")
                self.tblFoodList.setEmptyMessage("Search something")
            }
//            webserviceSearchModel(strSearch: query)
            arrSearchRestList.removeAll()
            arrSearchRestItemList.removeAll()
            tblRestaurant.reloadData()
            tblFoodList.reloadData()
        }else{
            if query.count > 2{
//                txtSearch.resignFirstResponder()
                webserviceSearchModel(strSearch: query)
            }
        }
    }
}
