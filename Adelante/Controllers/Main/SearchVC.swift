//
//  SearchVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage
class SearchVC: BaseViewController,UINavigationControllerDelegate, UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrSearchResult = [Datum]()
    private var lastSearchTxt = ""
    var refreshList = UIRefreshControl()
    // MARK: - IBOutlets
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tblSearch: UITableView!
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        tblSearch.delegate = self
        tblSearch.dataSource = self
        tblSearch.refreshControl = refreshList
        txtSearch.backgroundImage = UIImage()
        refreshList.addTarget(self, action: #selector(refreshFavList), for: .valueChanged)
        setUpLocalizedStrings()
        setup()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.customTabBarController?.showTabBar()
    }
    
    // MARK: - Other Methods
    @objc func refreshFavList() {
        self.webserviceSearchModel(strSearch: "")
    }
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: true, isRight: true)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.SearchVC.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, isShowHomeTopBar: false)
        //        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtSearch.frame.height))
        //               txtSearch.leftView = padding
        //               txtSearch.leftViewMode = UITextField.ViewMode.always
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchCell = tblSearch.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath)as! SearchCell
        cell.lblItem.text = arrSearchResult[indexPath.row].name
        cell.lblItemType.text = arrSearchResult[indexPath.row].type
        let strUrl = "\(APIEnvironment.profileBu.rawValue)\(arrSearchResult[indexPath.row].image ?? "")"
        cell.imgFoodandres.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgFoodandres.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrSearchResult[indexPath.row].type.caseInsensitiveCompare("dish") == .orderedSame{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "RestaurantListVC") as! RestaurantListVC
            vc.strItemId = arrSearchResult[indexPath.row].id
            vc.strItemType = arrSearchResult[indexPath.row].type
            self.navigationController?.pushViewController(vc, animated: true)
        }else if arrSearchResult[indexPath.row].type.caseInsensitiveCompare("restaurant") == .orderedSame{
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "RestaurantDetailsVC") as! RestaurantDetailsVC
            vc.selectedRestaurantId = arrSearchResult[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func setUpLocalizedStrings() {
        txtSearch.placeholder = "SearchVC_txtSearch".Localized()
    }
    
    // MARK: - IBActions
    
    // MARK: - Api Calls
    @objc func webserviceSearchModel(strSearch:String){
        let search = SearchReqModel()
        search.item = strSearch
        search.lat = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.latitude)"
        search.lng = "\(SingletonClass.sharedInstance.userCurrentLocation.coordinate.longitude)"
        WebServiceSubClass.search(Searchmodel: search, showHud: false, completion: { (response, status, error) in
            //self.hideHUD()
            if status{
                let result = SearchResModel(fromJson: response)
                self.arrSearchResult = result.data
                self.tblSearch.reloadData()
            }else{
                Utilities.showAlertOfAPIResponse(param: response, vc: self)
            }
            if self.arrSearchResult.count > 0{
                self.tblSearch.restore()
            }else {
                self.tblSearch.setEmptyMessage("No result found for ")
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
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall), object: lastSearchTxt)
        lastSearchTxt = searchText
        self.perform(#selector(self.makeNetworkCall), with: searchText, afterDelay: 0.7)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        txtSearch.resignFirstResponder()
    }
    @objc private func makeNetworkCall(_ query: String)
    {
        if query == ""{
            arrSearchResult.removeAll()
            tblSearch.reloadData()
        }else{
            if query.count > 2{
                webserviceSearchModel(strSearch: query)
            }
        }
    }
}
