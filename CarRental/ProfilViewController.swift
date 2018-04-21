//
//  ProfilViewController.swift
//  CarRental
//
//  Created by Admin on 18/04/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Kingfisher
class ProfilViewController: UIViewController {

    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        lblName.text = UserDefaults.standard.string(forKey: "name") as? String
        lblPhone.text = UserDefaults.standard.string(forKey: "phone") as? String
        lblEmail.text = UserDefaults.standard.string(forKey: "email") as? String
        lblAdress.text = UserDefaults.standard.string(forKey: "address") as? String
        let url = URL(string: (UserDefaults.standard.string(forKey: "photo") as? String)! )
        profilPic.kf.setImage(with: url)
        
        self.profilPic.layer.cornerRadius = 10.0
        self.profilPic.clipsToBounds = true;
        self.profilPic.layer.borderWidth = 3.0
        self.profilPic.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
