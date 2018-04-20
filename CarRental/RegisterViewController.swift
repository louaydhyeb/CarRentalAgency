//
//  RegisterViewController.swift
//  CarRental
//
//  Created by Admin on 16/04/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GooglePlaces
import GooglePlacePicker
import SwiftValidator
import MapKit


class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , GMSPlacePickerViewControllerDelegate,ValidationDelegate{
    
    
    let validator = Validator()
    let URLRegsiter = "http://192.168.254.129/Scripts/v1/upload2.php"
    var photoUrl: URL?
    
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var phonetxt: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var NameErrorLabel: UILabel!
    @IBOutlet weak var PasswordErrorLabel: UILabel!
    @IBOutlet weak var PhoneErrorLabel: UILabel!
    @IBOutlet weak var EmailErrorLabel: UILabel!
    @IBOutlet weak var AddressErrorLabel: UILabel!
    
    @IBAction func pickPlace(_ sender: UIButton) {
        
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func register(_ sender: Any) {
    
       validator.validate(delegate: self)
    }
    @IBAction func choose(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
         actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
         }))
        
         actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        Address.text = place.formattedAddress
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if  let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            photoUrl = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoUrl)
             picker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //validator.registerField(textField: Email, errorLabel: EmailErrorLabel, rules: [RequiredRule(message : "Email is required"), EmailRule(message: "Invalid email")])
         validator.registerField(textField: password, errorLabel: PasswordErrorLabel, rules: [RequiredRule(message : "Password is required"), PasswordRule()])
         validator.registerField(textField: nametxt, errorLabel: NameErrorLabel, rules: [RequiredRule(message : "Name is required")])
        validator.registerField(textField: phonetxt, errorLabel: PhoneErrorLabel, rules: [RequiredRule(message : "Phone is required"), MinLengthRule(length: 8)])
        validator.registerField(textField: Address, errorLabel: AddressErrorLabel, rules: [RequiredRule(message : "Address is required")])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validationSuccessful() {
        
        let parameters:Parameters=[
            //"image":photoUrl,
            "nameAgence":nametxt.text!,
            "password":password.text!,
            "email":Email.text!,
            "phone":phonetxt.text!,
            "address":Address.text!,
            ]
        
        // Image to upload:
        let imageToUploadURL = photoUrl
        
        // Server address (replace this with the address of your own server):
        //let url = "http://localhost:8888/upload_image.php"
        
        // Use Alamofire to upload the image
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                multipartFormData.append(imageToUploadURL!, withName: "image")
                for (key, val) in parameters {
                    multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        },
            to: URLRegsiter,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let jsonResponse = response.result.value as? [String: Any] {
                            print(jsonResponse)
                            self.performSegue(withIdentifier: "toLogin", sender: nil)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        Alamofire.request(URLRegsiter,method: .post, parameters: parameters ).responseJSON{
            
            response in
            print(response)
            
            if let result = response.result.value{
                
                let jsonData = result as! NSDictionary
                
                print(jsonData.value(forKey:"message")as! String? as Any)
            }
        }
    
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
            error.errorLabel?.textColor = UIColor.red
        }    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
