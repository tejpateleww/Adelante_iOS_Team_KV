//
//  sortPopupVC.swift
//  Adelante
//
//  Created by Apple on 08/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
@objc protocol SortListDelegate {
    func SelectedSortList(_ SortId: String)
}
class sortPopupVC: UIViewController,UITableViewDataSource ,UITableViewDelegate {
    
    // var customTabBarController: CustomTabBarVC?
    var refreshList = UIRefreshControl()
    var delegateFilter : SortListDelegate!
    var selectedSortData = "2"
    
    // @IBOutlet weak var heightViewBG: NSLayoutConstraint!
    @IBOutlet weak var tblSorting: UITableView!
    @IBOutlet weak var viewBG: UIView!
            @IBOutlet weak var lblSort: sortPopUPLabel!
    @IBOutlet weak var heightTblSorting: NSLayoutConstraint!
    
    var arrayForSort : [Sorting] = SingletonClass.sharedInstance.arrSorting
    
    
    
    @IBOutlet weak var viewDragable: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalizedStrings()
        isSwipable(view: viewDragable)
        
        // self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        let footerView = UIView()
        footerView.backgroundColor = .white
        footerView.frame = CGRect.init(x: 0, y: 0, width: tblSorting.frame.size.width, height: 5)
        tblSorting.tableFooterView = footerView
        
        // heightTblSorting.constant = tblSorting.contentSize.height - 30 + 77 + 20
        let verticalSafeAreaInset: CGFloat
        if #available(iOS 11.0, *) {
            verticalSafeAreaInset = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
               } else {
            verticalSafeAreaInset = 0.0
        }
        let safeAreaHeight = self.view.frame.height - verticalSafeAreaInset
        heightTblSorting.constant = tblSorting.contentSize.height
        if heightTblSorting.constant >= safeAreaHeight - 50
        {
            heightTblSorting.constant = safeAreaHeight - 50 - 77
        }
        
        print("111")
        
        tblSorting.delegate = self
        tblSorting.dataSource = self
        //        tblSorting.refreshControl = refreshList
        //        refreshList.addTarget(self, action: #selector(webser), for: .valueChanged)
        tblSorting.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.viewBG.layer.cornerRadius = 10
        self.viewBG.clipsToBounds = true
        self.viewBG.layer.shadowColor = colors.black.value.cgColor
        self.viewBG.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewBG.layer.shadowOpacity = 10
        self.viewBG.layer.shadowRadius = 10.0    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //
    //    }
    
    @IBAction func btnActionHide(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: notifDeSelectFilterHome, object: nil)
            NotificationCenter.default.post(name: notifDeSelectFilterRestaurant, object: nil)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: notifDeSelectFilterHome, object: nil)
            NotificationCenter.default.post(name: notifDeSelectFilterRestaurant, object: nil)
        })
    }
    
    //MARK: -tblViewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForSort.count
    }
    
    func setUpLocalizedStrings(){
        lblSort.text = "sortPopupVC_lblSort".Localized()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblSorting.dequeueReusableCell(withIdentifier: sortCell.reuseIdentifier, for: indexPath) as! sortCell
        cell.SortListName.text = arrayForSort[indexPath.row].name
        if arrayForSort[indexPath.row].id == selectedSortData
        {
            cell.imageSelected.isHighlighted = true
        } else {
            cell.imageSelected.isHighlighted = false
        }
        cell.btnClickNew = {
            if self.selectedSortData == ""{
                self.selectedSortData = self.arrayForSort[indexPath.row].id
                let selectedIndexpath = IndexPath(item: indexPath.row, section: 0)
                self.tblSorting.reloadRows(at: [selectedIndexpath], with: .automatic)
            }else if self.selectedSortData == self.arrayForSort[indexPath.row].id{
                self.selectedSortData = ""
                let selectedIndexpath = IndexPath(item: indexPath.row, section: 0)
                self.tblSorting.reloadRows(at: [selectedIndexpath], with: .automatic)
            }else{
                self.selectedSortData = self.arrayForSort[indexPath.row].id
                self.tblSorting.reloadData()
            }
            self.dismiss(animated: true) {
                self.delegateFilter.SelectedSortList(self.selectedSortData)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc public func dismissPresentView(){
        self.dismiss(animated: true) {
            
        }
    }
}
