//
//  HomeVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

struct structFilter {
    
    var strselectedImage : UIImage
    var strDeselectedImage:UIImage
    var strTitle : String
    init(strselectedImage:UIImage, strDeselectedImage:UIImage ,strTitle :String) {
        self.strselectedImage = strselectedImage
        self.strDeselectedImage = strDeselectedImage
        self.strTitle = strTitle
    }
}

class HomeVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIGestureRecognizerDelegate , RestaurantCatListDelegate ,SortListDelegate,favoriteDelegate{
    //    func SelectedCategory(_ CategoryId: String) -> (Bool, String) {
    //
    //        self.SelectedCatId = CategoryId
    //        self.webserviceGetDashboard()
    //    }
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrFilter = [structFilter(strselectedImage: UIImage.init(named: "filterImageSelected")! , strDeselectedImage: UIImage.init(named: "filterImage")!, strTitle: ""),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title1".Localized()),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title2".Localized()),
                     structFilter(strselectedImage: UIImage(), strDeselectedImage: UIImage(), strTitle: "HomeVC_arrFilter_title3".Localized())] //["","Mobile Pickup", "Recently Viewed", "Top Rated"]
    var arrImagesForPage = ["dummyRest1", "dummyRest2" , "dummyRest1"]
    var arrImages = ["dummyRest1", "dummyRest2" , "dummyRest1", "dummyRest1", "dummyRest2" , "dummyRest1"]
    var selectedSortTypedIndexFromcolVwFilter = 1
    var refresher = UIRefreshControl()
    var arrCategories = [Category]()
    var arrRestaurant  = [Restaurant]()
    var arrBanner = [Banner]()
    var SelectedCatId = ""
    var SelectFilterId = ""
    var refreshList = UIRefreshControl()
    var pageNumber = 1
    var isNeedToReload = true
    var pageLimit = 5
    var selectedRestaurantId = ""
    // MARK: - IBOutlets
    @IBOutlet weak var lblMylocation: myLocationLabel!
    @IBOutlet weak var lblAddress: myLocationLabel!
    @IBOutlet weak var colVwRestWthPage: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblMainList: UITableView!
    @IBOutlet weak var colVwFilterOptions: UICollectionView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        webserviceGetDashboard()
        tblMainList.refreshControl = refreshList
        refreshList.addTarget(self, action: #selector(refreshListing), for: .valueChanged)
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonTapFavorite), for: .touchUpInside)
        setup()
        pageControl.numberOfPages = arrBanner.count
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: false, isRight: false)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        lblNavAddressHome.text = "30 Memorial Drive, Avon MA 2322"
        btnNavAddressHome.addTarget(self, action: #selector(btnNavAddressHomeClicked(_:)), for: .touchUpInside)
        
        NotificationCenter.default.removeObserver(self, name: notifDeSelectFilterHome, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deSelectFilterAndRefresh), name: notifDeSelectFilterHome, object: nil)
        NotificationCenter.default.removeObserver(self, name: notifRefreshDashboardList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListing), name: notifRefreshDashboardList, object: nil)
        
        colVwRestWthPage.delegate = self
        colVwRestWthPage.dataSource = self
        colVwRestWthPage.reloadData()
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
        
        
        colVwFilterOptions.delegate = self
        colVwFilterOptions.dataSource = self
        colVwFilterOptions.reloadData()
        
        pageControl.hidesForSinglePage = true
    }
    @objc func refreshListing(){
        pageNumber = 1
        self.isNeedToReload = true
        webserviceGetDashboard()
    }
    @objc func deSelectFilterAndRefresh() {
        selectedSortTypedIndexFromcolVwFilter = -1
        colVwFilterOptions.reloadData()
    }
    func setUpLocalizedStrings(){
        lblMylocation.text = "HomeVC_lblMylocation".Localized()
        lblAddress.text = "30 Memorial Drive, Avon MA 2322"
    }
    // MARK: - IBActions
    @IBAction func buttonTapFavorite(_ sender: UIButton) {
        if userDefault.object(forKey: UserDefaultsKey.isUserLogin.rawValue) as? Bool == false{
            let vc = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginViewController.storyboardID) as! LoginViewController
            let navController = UINavigationController.init(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            navController.navigationController?.modalTransitionStyle = .crossDissolve
            navController.navigationBar.isHidden = true
            SingletonClass.sharedInstance.isPresented = true
            self.present(navController, animated: true, completion: nil)
        }else{
            var Select = arrRestaurant[sender.tag].favourite ?? ""
            let restaurantId = arrRestaurant[sender.tag].id ?? ""
            if Select == "1"{
                Select = "0"
            }else{
                Select = "1"
            }
            webwerviceFavorite(strRestaurantId: restaurantId, Status: Select)
        }
    }
    @IBAction func btnNotifClicked(_ sender: Any) {
        let notifVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: NotificationVC.storyboardID)
        self.navigationController?.pushViewController(notifVc, animated: true)
    }
    
    @IBAction func btnNavAddressHomeClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "EditLocationVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            if self.selectedSortTypedIndexFromcolVwFilter == -1 {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                let selectedIndexPath = IndexPath(item:self.selectedSortTypedIndexFromcolVwFilter , section: 0)
                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
            }
            else if self.selectedSortTypedIndexFromcolVwFilter == sender.tag{
                self.selectedSortTypedIndexFromcolVwFilter = 1
//                let selectedIndexPath = IndexPath(item:sender.tag , section: 0)
//                self.colVwFilterOptions.reloadItems(at: [selectedIndexPath])
                self.colVwFilterOptions.reloadData()
            } else {
                self.selectedSortTypedIndexFromcolVwFilter = sender.tag
                self.colVwFilterOptions.reloadData()
            }
            if self.selectedSortTypedIndexFromcolVwFilter == 0 {
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: sortPopupVC.storyboardID) as! sortPopupVC
                vc.delegateFilter = self
                vc.selectedSortData = self.SelectFilterId
                let navController = UINavigationController.init(rootViewController: vc)
                navController.modalPresentationStyle = .overFullScreen
                navController.navigationController?.modalTransitionStyle = .crossDissolve
                navController.navigationBar.isHidden = true
                self.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UICollectionView Delegates And Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colVwFilterOptions{
            return arrFilter.count
        } else if collectionView == self.colVwRestWthPage {
            return arrBanner.count
        }
        return arrRestaurant.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colVwFilterOptions{
            let cell = colVwFilterOptions.dequeueReusableCell(withReuseIdentifier: FilterOptionsCell.reuseIdentifier, for: indexPath) as! FilterOptionsCell
            cell.btnFilterOptions.setTitle(arrFilter[indexPath.row].strTitle, for: .normal)
            
            if selectedSortTypedIndexFromcolVwFilter != -1 && selectedSortTypedIndexFromcolVwFilter == indexPath.row {
                cell.btnFilterOptions.backgroundColor = colors.segmentSelectedColor.value
                cell.btnFilterOptions.setImage(arrFilter[indexPath.row].strselectedImage, for: .normal)
                cell.btnFilterOptions.setTitleColor(UIColor(hexString: "#000000"), for: .normal)
            }
            else {
                cell.btnFilterOptions.backgroundColor = colors.segmentDeselectedColor.value
                cell.btnFilterOptions.setImage(arrFilter[indexPath.row].strDeselectedImage, for: .normal)
                cell.btnFilterOptions.setTitleColor(colors.black.value.withAlphaComponent(0.3), for: .normal)
            }
            cell.btnFilterOptions.isUserInteractionEnabled = true
            cell.btnFilterOptions.tag = indexPath.row
            cell.btnFilterOptions.addTarget(self, action: #selector(btnFilterClicked(_:)), for: .touchUpInside)
            return cell
        }else {
            let cell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: RestWithPageCell.reuseIdentifier, for: indexPath) as! RestWithPageCell
            let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrBanner[indexPath.row].image ?? "")"
            cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            if cell.lblRestName.text == ""{
                cell.vwRestName.isHidden = true
            }else{
                cell.vwRestName.isHidden = false
            }
            if cell.lblRestDesc.text == ""{
                cell.vwRestDesc.isHidden = true
            }else{
                cell.vwRestDesc.isHidden = false
            }
            cell.lblRestName.text = arrBanner[indexPath.row].name
            cell.lblRestDesc.text = arrBanner[indexPath.row].descriptionField
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.colVwFilterOptions{
            if indexPath.row == 0 {
                return CGSize(width: colVwFilterOptions.frame.size.height, height: colVwFilterOptions.frame.size.height)
            }
            let s = arrFilter[indexPath.row].strTitle.size(withAttributes:[.font: CustomFont.NexaRegular.returnFont(14)])
            return CGSize(width: s.width + 20, height: colVwFilterOptions.frame.size.height)
        } else {
            return CGSize(width: colVwRestWthPage.frame.size.width, height: colVwRestWthPage.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.colVwRestWthPage {
            self.pageControl.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.colVwFilterOptions{
            let restListVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantListVC.storyboardID)
            self.navigationController?.pushViewController(restListVc, animated: true)
        }
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRestaurant.count + 1    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCatListCell.reuseIdentifier, for: indexPath) as! RestaurantCatListCell
            cell.arrCategories = self.arrCategories
            cell.delegateResCatCell = self
            cell.colRestaurantCatList.reloadData()
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
            cell.lblItemName.text = arrRestaurant[indexPath.row - 1].name
            cell.lblMiles.text = arrRestaurant[indexPath.row - 1].distance//arrRestaurant[indexPath.row - 1].distance
            cell.lblRating.text = arrRestaurant[indexPath.row - 1].review
            let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrRestaurant[indexPath.row - 1].image ?? "")"
            cell.imgRestaurant.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgRestaurant.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
            cell.btnFavorite.tag = indexPath.row - 1
            cell.btnFavorite.addTarget(self, action: #selector(buttonTapFavorite(_:)), for: .touchUpInside)
            if arrRestaurant[indexPath.row - 1].favourite == "1"{
                cell.btnFavorite.isSelected = true
            }else{
                cell.btnFavorite.isSelected = false
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0
        {
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantOutletVC.storyboardID) as! RestaurantOutletVC
            controller.selectedRestaurantId = arrRestaurant[indexPath.row - 1].id
            controller.strRestaurantName = arrRestaurant[indexPath.row - 1].name
//            controller.selectedIndex = "\(indexPath.row - 1)"
//            controller.isFromDeshboard = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    // MARK: - RestaurantCatListCelldelegate
    func SelectedCategory(_ CategoryId: String) {
        self.SelectedCatId = CategoryId
        print("selectedcategoryid",SelectedCatId)
        pageNumber = 1
        self.webserviceGetDashboard()
    }
    // MARK: - filterDelegate
    func SelectedSortList(_ SortId: String) {
        DispatchQueue.main.async {
            self.selectedSortTypedIndexFromcolVwFilter = -1
            self.colVwFilterOptions.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        if SingletonClass.sharedInstance.topSellingId != "" && SortId == SingletonClass.sharedInstance.topSellingId{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "CategoryVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.SelectFilterId = SortId
            pageNumber = 1
            webserviceGetDashboard()
        }
    }
    // MARK: - UIScrollView Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
        if isNeedToReload {
            pageNumber = pageNumber + 1
            webserviceGetDashboard()
        }
        // done, do whatever
    }
    // MARK: - Api Calls
    @objc func webserviceGetDashboard(){
        let Deshboard = DashboardReqModel()
        Deshboard.category_id = SelectedCatId
        Deshboard.user_id = SingletonClass.sharedInstance.UserId
        Deshboard.filter = SelectFilterId
        Deshboard.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        Deshboard.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        Deshboard.page = "\(pageNumber)"
        WebServiceSubClass.deshboard(DashboardModel: Deshboard, showHud: true, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let Homedata = DashBoardResModel.init(fromJson: response)
                self.arrCategories = Homedata.category
                self.arrBanner = Homedata.banner
                self.pageControl.numberOfPages = self.arrBanner.count
                if self.pageNumber == 1 {
                    self.arrRestaurant = Homedata.restaurant
                } else {
                    let arrTemp = Homedata.restaurant
                    if arrTemp!.count > 0 {
                        for i in 0..<arrTemp!.count {
                            self.arrRestaurant.append(arrTemp![i])
                        }
                    }
                    if arrTemp!.count < self.pageLimit {
                        self.isNeedToReload = false
                    }
                }
                self.tblMainList.reloadData()
                self.colVwRestWthPage.reloadData()
            }else{
                Utilities.displayErrorAlert(response["message"].string ?? "Something went wrong")
                //                Utilities.showAlertOfAPIResponse(param: error ?? "Something went wrong", vc: self)
            }
            if self.arrRestaurant.count > 0{
                self.tblMainList.restore()
            }else {
                self.tblMainList.setEmptyMessage("emptyMsg_Restaurant".Localized())
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
        WebServiceSubClass.Favorite(Favoritemodel: favorite, showHud: true, completion: { (response, status, error) in
            //            self.hideHUD()
            if status{
//                self.webserviceGetDashboard()
                self.arrRestaurant.first(where: { $0.id == strRestaurantId })?.favourite = Status
                self.tblMainList.reloadData()
                NotificationCenter.default.post(name: notifRefreshRestaurantList, object: nil)
            }else{
                Utilities.showAlertOfAPIResponse(param: error, vc: self)
            }
        })
    }
    func refreshDeshboardList(strStatus: String, selectedIndex: String) {
        pageNumber = 1
        self.isNeedToReload = true
        webserviceGetDashboard()
//        if selectedIndex != ""{
//            let i = Int(selectedIndex) ?? 0
//            arrRestaurant[i].favourite = strStatus
//            tblMainList.reloadRows(at: [IndexPath(row: i + 1, section: 0)], with: .automatic)
//        }
    }
    
    func refreshFavoriteScreen() {
        webserviceGetDashboard()
    }
}
