//
//  sortPopupVC.swift
//  Adelante
//
//  Created by Apple on 08/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class sortPopupVC: UIViewController,UITableViewDataSource ,UITableViewDelegate {
    
   // var customTabBarController: CustomTabBarVC?
    // @IBOutlet weak var heightViewBG: NSLayoutConstraint!
    @IBOutlet weak var tblSorting: UITableView!
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var heightTblSorting: NSLayoutConstraint!
    
    var arrayForSort : [String] = ["Picked for you","Nearest","Popular near you","Today’s special","Top selling","Loved by locals"]
    
    // var arrayForSort : [String] = ["Picked for you Picked for you Picked for you Picked for you Picked for you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you","Nearest Nearest Nearest Nearest","Popular near you Popular near you Popular near you Popular near you"]
    
    @IBOutlet weak var viewDragable: UIView!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
    }
 
    override func viewDidLayoutSubviews() {
        self.viewBG.layer.cornerRadius = 10
        self.viewBG.clipsToBounds = true
        
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //
    //    }
    
    @IBAction func btnActionHide(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name("deselectFilterOptionHome"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("deselectFilterOptionRest"), object: nil)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name("deselectFilterOptionHome"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("deselectFilterOptionRest"), object: nil)
        })
    }
    
    //MARK: -tblViewMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForSort.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblSorting.dequeueReusableCell(withIdentifier: sortCell.reuseIdentifier, for: indexPath) as! sortCell
        cell.SortListName.text = arrayForSort[indexPath.row]
        
        cell.imageSelected.isHighlighted = selectedIndex == indexPath.row ? true : false
        cell.btnClickNew = {
            self.selectedIndex = indexPath.row
            self.tblSorting.reloadData()
            switch indexPath.row {
            case 0:
                self.dismiss(animated: true, completion: nil)
            case 4:
                let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: CategoryVC.storyboardID) as! CategoryVC
                self.navigationController?.navigationBar.isHidden = false
                       self.navigationController?.pushViewController(controller, animated: true)
                //self.dismiss(animated: true, completion: nil)
              
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
   
        
    }
    
    @objc public func dismissPresentView(){
        self.dismiss(animated: true) {
            
        }
    }
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return tblSorting.
     }
     */
}
class sortCell : UITableViewCell
{
    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var SortListName: UILabel!
    var btnClickNew : (() -> ())?
    

    @IBAction func btnClick(_ sender: Any) {
        if let click = self.btnClickNew
        {
            click()
        }
    }
}
