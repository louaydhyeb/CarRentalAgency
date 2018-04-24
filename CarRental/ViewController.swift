//
//  ViewController.swift
//  CarRental
//
//  Created by Admin on 16/04/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {
    
    let agence = Agence()
    
    let URLLogin = "http://192.168.254.129/Scripts/v1/agenceLogin.php"
    @IBOutlet weak var usertxt: UITextField!
    @IBOutlet weak var passtxt: UITextField!
    @IBAction func login(_ sender: UIButton) {
        doLogin()
    }
    func doLogin(){
        let parameters:Parameters=[
            "name":usertxt.text!,
            "password":passtxt.text!,
            ]
        Alamofire.request(URLLogin, method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["error"] == false{
                    print("logged in")
                    let id = String(describing: json["idagence"])
                    let a = String(describing: json["name"])
                    let b = String(describing: json["phone"])
                    let c = String(describing: json["email"])
                    let d = String(describing: json["photo"])
                    let e = String(describing: json["address"])
                    
                    var defaults = UserDefaults.standard
                    defaults.set(a,     forKey: "name")
                    defaults.set(b,     forKey: "phone")
                    defaults.set(c,     forKey: "email")
                    defaults.set(d,     forKey: "photo")
                    defaults.set(e,     forKey: "address")
                    defaults.set(id,     forKey: "idagence")
                    
                    defaults.synchronize()
                    
                    //UserDefaults.standard.set(a, forKey: "name")
                    self.performSegue(withIdentifier: "toMenu", sender: nil)
                } else if json["error"] == true {
                    print("not loggedin")
                    let message = "wrong password "
                    let alert = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print("JSON: \(json)")
                let message = "wrong email "
                let alert2 = UIAlertController(title: "Wrong", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            case .failure(let error):
                print(error)
                let message = "cannot reach server "
                let alert2 = UIAlertController(title: "error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert2, animated: true, completion: nil)
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "aaaaa.jpeg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        let preferences = UserDefaults.standard
        
        if(preferences.string(forKey: "name") != nil)
        {
            self.performSegue(withIdentifier: "toMenu", sender: nil)
            print("T3adit")
        }
    }


}

