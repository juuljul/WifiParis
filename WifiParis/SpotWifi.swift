//
//  SpotWifi.swift
//  WifiParis
//
//  Created by Julien Bremeersch on 12/06/2017.
//  Copyright © 2017 Julien Bremeersch. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class SpotWifi: NSObject, MKAnnotation {
    let title: String?
    let nomSite: String
    let arrondissement: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, nomSite: String, arrondissement: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.nomSite = nomSite
        self.arrondissement = arrondissement
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return nomSite
    }
    
    
    // Premier et 2e arrondissements en rouge, 3e et 4e en violet, les autres en vert
    func pinTintColor() -> UIColor  {
        switch arrondissement {
        case "75001", "75002":
            return MKPinAnnotationView.redPinColor()
        case "75003", "75004":
            return MKPinAnnotationView.purplePinColor()
        default:
            return MKPinAnnotationView.greenPinColor()
        }
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}

