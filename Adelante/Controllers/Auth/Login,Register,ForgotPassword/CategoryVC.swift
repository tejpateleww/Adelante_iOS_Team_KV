//
//  CategoryVC.swift
//  Adelante
//
//  Created by baps on 02/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.tfSearch.frame.height))
        tfSearch.leftView = padding
        tfSearch.leftViewMode = UITextField.ViewMode.always
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CategoryCell = collectionCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)as! CategoryCell
        return cell
    }
    
}
class CategoryCell : UICollectionViewCell{
    
}
