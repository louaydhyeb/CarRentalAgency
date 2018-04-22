//
//  ProfilViewController.swift
//  CarRental
//
//  Created by Admin on 18/04/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Kingfisher
class ProfilViewController: UIViewController, TwicketSegmentedControlDelegate , UITableViewDataSource , UITableViewDelegate {
    
   
    
    func didSelect(_ segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            self.tableViewComments.isHidden = false
            self.RateView.isHidden = true
        case 1:
            self.tableViewComments.isHidden = true
            self.RateView.isHidden = false
        default:
            self.tableViewComments.isHidden = true
            self.RateView.isHidden = true
        }
    }
    

    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var tableViewComments: UITableView!
    @IBOutlet weak var RateView: UIView!
    
    @IBOutlet weak var segmentedControl: TwicketSegmentedControl!
    let titles = ["Comments","Rate"]
    let a = ["Comments","Rate","Comments","Louay","Comments","Marwen","Comments","Rate","Ali","Rate","Comments","Rate","Khlaed","Ya RAbi"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = a[indexPath.row]
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        lblName.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblEmail.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblName.text = UserDefaults.standard.string(forKey: "name") as? String
        lblPhone.text = UserDefaults.standard.string(forKey: "phone") as? String
        lblEmail.text = UserDefaults.standard.string(forKey: "email") as? String
        lblAdress.text = UserDefaults.standard.string(forKey: "address") as? String
        let url = URL(string: (UserDefaults.standard.string(forKey: "photo") as? String)! )
        profilPic.kf.setImage(with: url)
        
        profilPic.layer.borderWidth = 1
        profilPic.layer.masksToBounds = false
        profilPic.layer.borderColor = UIColor.black.cgColor
        profilPic.layer.cornerRadius = profilPic.frame.height/2
        profilPic.clipsToBounds = true
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        self.RateView.isHidden = true
        self.tableViewComments.isHidden = false
        tableViewComments.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




