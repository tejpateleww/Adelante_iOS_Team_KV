//
//  RestaurantReviewVC.swift
//  Adelante
//
//  Created by baps on 03/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class RestaurantReviewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tbvReview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell:ReViewDiscCell = tbvReview.dequeueReusableCell(withIdentifier: "ReViewDiscCell", for: indexPath)as! ReViewDiscCell
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
class ReViewCell:UITableViewCell{
    
}
class ReViewDiscCell:UITableViewCell{
    
}
