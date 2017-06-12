//
//  ViewController.swift
//  WifiParis
//
//  Created by Julien Bremeersch on 12/06/2017.
//  Copyright © 2017 Julien Bremeersch. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        On place la carte au centre de Paris
        let initialLocation = CLLocation(latitude: 48.86, longitude: 2.34)
        centerMapOnLocation(initialLocation)
        
        loadInitialData()
        mapView.addAnnotations(spotWifis)
        
        mapView.delegate = self
    }
    
    var spotWifis = [SpotWifi]()
    func loadInitialData() {
        let fileName = Bundle.main.path(forResource: "HotspotWifiParis", ofType: "json");
        var data: Data?
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: fileName!), options: NSData.ReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        var jsonTableauOrigine: Any? = nil
        if let data = data {
            do {
                jsonTableauOrigine = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            } catch _ {
                jsonTableauOrigine = nil
            }
        }
        if let jsonTableauOrigine = jsonTableauOrigine as? [[String: Any]],
            let jsonValueTableauOrigine = JSONValue.fromObject(jsonTableauOrigine)?.array{
            for SpotWifiJSON in jsonValueTableauOrigine {
                if let SpotWifiJSON = SpotWifiJSON.object{
                    if let fieldsObject = SpotWifiJSON["fields"]?.object,
                        let title = fieldsObject["adresse"]?.string,
                        let arrondissement = fieldsObject["arrondissement"]?.string,
                        let nomSite = fieldsObject["nom_site"]?.string,
                        let geo = fieldsObject["geo_point_2d"]?.array{
                        let latitude = geo[0].double!
                        let longitude = geo[1].double!
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let spotWifi = SpotWifi(title: title, nomSite: nomSite, arrondissement: arrondissement, coordinate: coordinate)
                        spotWifis.append(spotWifi)
                    }
                }
            }
        }
    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}


