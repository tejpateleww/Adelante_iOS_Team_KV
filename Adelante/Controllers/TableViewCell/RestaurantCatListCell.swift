//
//  RestaurantCatListCell.swift
//  Adelante
//
//  Created by baps on 23/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol RestaurantCatListDelegate {
    func SelectedCategory(_ CategoryId: String)
}

class RestaurantCatListCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var selectedIdForFood = "0"
    var delegateResCatCell : RestaurantCatListDelegate?
    var arrCategories = [Category]()
    var selectedIndexPath = IndexPath()
    @IBOutlet weak var colRestaurantCatList: UICollectionView!
    
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
    @IBAction func btnCategortClick(_ sender : UIButton){
        DispatchQueue.main.async {
            if self.selectedIdForFood == "" {
                self.selectedIdForFood = self.arrCategories[sender.tag].id
                let selectedIndexPath = IndexPath(item:sender.tag , section: 0)
                self.colRestaurantCatList.reloadItems(at: [selectedIndexPath])
            }
            else if self.selectedIdForFood == self.arrCategories[sender.tag].id{
                self.selectedIdForFood = ""
                let selectedIndexPath = IndexPath(item:sender.tag , section: 0)
                self.colRestaurantCatList.reloadItems(at: [selectedIndexPath])
            } else {
                self.selectedIdForFood = self.arrCategories[sender.tag].id
                self.colRestaurantCatList.reloadData()
            }
        }
        self.delegateResCatCell?.SelectedCategory(selectedIdForFood)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colRestaurantCatList.dequeueReusableCell(withReuseIdentifier: RestaurantCategoryCell.reuseIdentifier, for: indexPath) as! RestaurantCategoryCell
        // cell.btnCategory.setTitle(arrCategories[indexPath.row].name, for: .normal)
        cell.lblCategory.text = arrCategories[indexPath.row].name
        let strUrl = "\(APIEnvironment.profileBaseURL.rawValue)\(arrCategories[indexPath.row].image ?? "")"
        cell.imgCategory.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgCategory.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        //           cell.btnCategory.setImage(image, for: .normal)
        if arrCategories[indexPath.row].id.contains(selectedIdForFood)
        {
            cell.viewCategory.backgroundColor = colors.segmentSelectedColor.value
        } else {
            cell.viewCategory.backgroundColor = colors.segmentDeselectedColor.value
        }
        //        cell.btnCategory.tag = indexPath.row
        //        cell.btnCategory.addTarget(self, action: #selector(btnCategortClick(_:)), for: .touchUpOutside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = arrCategories[indexPath.row].name.size(withAttributes:[.font: CustomFont.NexaRegular.returnFont(14)])
        return CGSize(width: s.width + 20 + 35, height: colRestaurantCatList.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIdForFood == "" {
            self.selectedIdForFood = self.arrCategories[indexPath.row].id
            selectedIndexPath = IndexPath(item:indexPath.row, section: 0)
            self.colRestaurantCatList.reloadItems(at: [selectedIndexPath])
        }
        else if self.selectedIdForFood == self.arrCategories[indexPath.row].id{
            self.selectedIdForFood = ""
            selectedIndexPath = IndexPath(item:indexPath.row , section: 0)
            self.colRestaurantCatList.reloadItems(at: [selectedIndexPath])
        } else {
            self.selectedIdForFood = self.arrCategories[indexPath.row].id
            self.colRestaurantCatList.reloadData()
        }
        //        }
        self.delegateResCatCell?.SelectedCategory(selectedIdForFood)
    }
}
