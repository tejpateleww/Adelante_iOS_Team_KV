//
//  HomeVC.swift
//  Adelante
//
//  Created by apple on 30/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit


class HomeVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var customTabBarController: CustomTabBarVC?
    var arrFilter = ["Mobile Pickup", "Recently Viewed", "Top Rated"]
    var arrImagesForPage = ["dummyRest1", "dummyRest2" , "dummyRest1"]
    var arrImages = ["dummyRest1", "dummyRest2" , "dummyRest1", "dummyRest1", "dummyRest2" , "dummyRest1"]
    
    // MARK: - IBOutlets
    @IBOutlet weak var colVwFilter: UICollectionView!
    @IBOutlet weak var colVwRestWthPage: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblMainList: UITableView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    // MARK: - Other Methods
    func setup() {
        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        addNavBarImage(isLeft: false, isRight: false)
        setNavigationBarInViewController(controller: self, naviColor: colors.appOrangeColor.value, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.notifBell.value], isTranslucent: true, isShowHomeTopBar: true)
        lblNavAddressHome.text = "30 Memorial Drive, Avon MA 2322"
        btnNavAddressHome.addTarget(self, action: #selector(btnNavAddressHomeClicked(_:)), for: .touchUpInside)
        
        colVwFilter.delegate = self
        colVwFilter.dataSource = self
        colVwFilter.reloadData()
        colVwRestWthPage.delegate = self
        colVwRestWthPage.dataSource = self
        colVwRestWthPage.reloadData()
        tblMainList.delegate = self
        tblMainList.dataSource = self
        tblMainList.reloadData()
        pageControl.hidesForSinglePage = true
    }
    
    // MARK: - IBActions
    @IBAction func btnNavAddressHomeClicked(_ sender: Any) {
        
    }
    
    // MARK: - UICollectionView Delegates And Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colVwFilter {
            return arrFilter.count + 1
        } else if collectionView == self.colVwRestWthPage {
            return arrImagesForPage.count
        }
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colVwFilter {
            let cell = colVwFilter.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath) as! FilterCell
            if indexPath.row == 0{
                cell.btnFilter.setTitle("", for: .normal)
                cell.btnFilter.setImage(UIImage.init(named: "filterImage"), for: .normal)
            } else {
                cell.btnFilter.setTitle(arrFilter[indexPath.row - 1], for: .normal)
            }
            return cell
        } else {
            let cell = colVwRestWthPage.dequeueReusableCell(withReuseIdentifier: RestWithPageCell.reuseIdentifier, for: indexPath) as! RestWithPageCell
            cell.imgRestaurant.image = UIImage(named: arrImagesForPage[indexPath.row])
            cell.lblRestName.text = "Lorem Ipsum"
            cell.lblRestDesc.text = "Lorem Ipsum is simply dummy text"
            return cell
        }
    }   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.colVwFilter {
            if indexPath.row == 0 {
                return CGSize(width: colVwFilter.frame.size.height, height: colVwFilter.frame.size.height)
            }
            let s = arrFilter[indexPath.row - 1].size(withAttributes:[.font: CustomFont.NexaRegular.returnFont(14)])
            return CGSize(width: s.width + 20, height: colVwFilter.frame.size.height)
        } else {
            return CGSize(width: colVwRestWthPage.frame.size.width - 10, height: colVwRestWthPage.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.colVwRestWthPage {
            self.pageControl.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.colVwFilter {
            
        } else {
            let restListVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: RestaurantListVC.storyboardID)
            self.navigationController?.pushViewController(restListVc, animated: true)
        }
    }
    // MARK: - UITableViewDelegates And Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCatListCell.reuseIdentifier, for: indexPath) as! RestaurantCatListCell
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tblMainList.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
                cell.selectionStyle = .none
                return cell
            }
            
    }
    
    // MARK: - Api Calls
    
}

// MARK: - UICollectionViewCell - FilterCell
class FilterCell : UICollectionViewCell {
    
    @IBOutlet weak var btnFilter: collectionVwFilterBtns!
    
    override func awakeFromNib() {
           super.awakeFromNib()
    }
}

// MARK: - UICollectionViewCell - RestWithPageCell
class RestWithPageCell : UICollectionViewCell {
    
    @IBOutlet weak var imgRestaurant: customImageView!
    @IBOutlet weak var lblRestName: colVwRestaurantLabel!
    @IBOutlet weak var lblRestDesc: colVwRestaurantLabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
    }
}

// MARK: - UICollectionViewCell - RestaurantCategoryCell
class RestaurantCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var btnCategory: collectionVwFilterBtns!
    
    override func awakeFromNib() {
           super.awakeFromNib()
    }
}

// MARK: - UITableViewCell - RestaurantCell
class RestaurantCatListCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var colRestaurantCatList: UICollectionView!
    
    var arrCategories = ["Pizza", "Fast Food", "Sandwich"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colRestaurantCatList.delegate = self
        self.colRestaurantCatList.dataSource = self
        self.colRestaurantCatList.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colRestaurantCatList.dequeueReusableCell(withReuseIdentifier: RestaurantCategoryCell.reuseIdentifier, for: indexPath) as! RestaurantCategoryCell
        cell.btnCategory.setTitle(arrCategories[indexPath.row], for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = arrCategories[indexPath.row].size(withAttributes:[.font: CustomFont.NexaRegular.returnFont(14)])
        return CGSize(width: s.width + 20 + 35, height: colRestaurantCatList.frame.size.height)
    }
}

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var imgRestaurant: customImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


