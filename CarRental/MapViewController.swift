//
//  MapViewController.swift
//  CarRental
//
//  Created by Admin on 20/04/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON
class MapViewController: UIViewController, GMSMapViewDelegate {

    let URL_GET_TEAMS:String = "http://192.168.254.129/Scripts/v1/showAddress.php"
    
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 36.806495, longitude: 10.181532, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        Alamofire.request(URL_GET_TEAMS, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
               
                for i in 0..<json.count {
                
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: json[i]["AgenceLat"].doubleValue, longitude: json[i]["AgenceLong"].doubleValue)
                    marker.title =  json[i]["AgenceName"].stringValue
                    marker.snippet = "Australia"
                    marker.map = mapView
                }
                    
                

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
        
       
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
