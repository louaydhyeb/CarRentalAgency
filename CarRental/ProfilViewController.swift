//
//  ProfilViewController.swift
//  CarRental
//
//  Created by Admin on 18/04/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Kingfisher


class ProfilViewController: UIViewController, TwicketSegmentedControlDelegate , UITableViewDataSource , UITableViewDelegate {
    
   
    let URL_GET_DATA = "http://192.168.254.129/Scripts/v1/FeedbackShow.php"
     var feedbacks = [Feedback]()
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
        return feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewControllerTableViewCell
        
        //getting the hero for the specified position
        let feedback: Feedback
        feedback = feedbacks[indexPath.row]
        
        //displaying values
        cell.feedbacklbl.text = feedback.feedback
        
        cell.imgUser.layer.borderWidth = 1
        cell.imgUser.layer.masksToBounds = false
        cell.imgUser.layer.borderColor = UIColor.black.cgColor
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        cell.imgUser.clipsToBounds = true
        //displaying image
        Alamofire.request(feedback.imageUrl!).responseImage { response in
            debugPrint(response)
            
            if let image = response.result.value {
                cell.imgUser.image = image
            }
        }
        
        return cell
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
        tableViewComments.delegate = self
        
        print(UserDefaults.standard.string(forKey: "idagence")!)
        
        
        let params:Parameters=[
            "id": UserDefaults.standard.string(forKey: "idagence")!
        ]
        Alamofire.request(URL_GET_DATA,method: .post, parameters: params).responseJSON { response in
            
            //getting json
            if let json = response.result.value {
                
                //converting json to NSArray
                let feedArray : NSArray  = json as! NSArray
                print(json)
                //traversing through all elements of the array
                for i in 0..<feedArray.count{
                    
                    //adding hero values to the hero list
                    self.feedbacks.append(Feedback(
                        feedback: (feedArray[i] as AnyObject).value(forKey: "feedback") as? String,
                        imageUrl: (feedArray[i] as AnyObject).value(forKey: "picture") as? String
                        
                    ))
                    
                }
                
                //displaying data in tableview
                self.tableViewComments.reloadData()
            }
            
        }
        
        
        
         self.tableViewComments.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




