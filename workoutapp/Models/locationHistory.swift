//
//  location.swift
//  workoutapp
//
//  Created by Negar on 2019-12-02.
//  Copyright © 2019 Negar. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class location: Object {
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
    @objc dynamic var occurence : Int = 0
    
    func set(lat: Double, long: Double, occ:Int = 0) {
        self.latitude = lat
        self.longitude = long
        self.occurence = occ
    }
    
    func add(){
        let allRegions = getAllRegions()
        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                for r in allRegions {
                    if (r.contains(center)){
                        increaseOccurence(r: r)
                        return
                    }
                }
                addNew()
            case .notDetermined, .restricted, .denied:
                break
        }
        
    }
    
    func increaseOccurence(r: CLCircularRegion){
        let realm = try! Realm()
        let specificLocation = realm.objects(location.self).filter("latitude == \(r.center.latitude) && longitude == \(r.center.longitude)").first
        try! realm.write {
            specificLocation!.occurence += 1
        }
        print(specificLocation as Any)
        
    }
    
    func getRegion()->CLCircularRegion{
        let locationManager = CLLocationManager()
        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let maxDistance = locationManager.maximumRegionMonitoringDistance
        //find the best radius**********************
        return CLCircularRegion(center: center, radius: 10.0, identifier: "")
    }
    
    func getAllRegions()->[CLCircularRegion]{
        let realm = try! Realm()
        let locations = Array(realm.objects(location.self))
        var results : [CLCircularRegion] = []
        
        for location in locations {
            results.append(location.getRegion())
        }
        return results
    }
    
    func addNew(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(location(value: [self.latitude, self.longitude, Int(1)]))
        }
    }
    
    class func getMostRecordedLocation()->location{
        let realm = try! Realm()
        let locationManager = CLLocationManager()
        let objects = realm.objects(location.self)
        if( objects.isEmpty )
        {
            let currentLocation: CLLocationCoordinate2D = locationManager.location!.coordinate
            var loc = location()
            loc.set(lat:currentLocation.latitude , long:currentLocation.longitude, occ: 1)
            try! realm.write {
                realm.add(loc)
            }
            return loc
        }
        return objects.sorted(byKeyPath: "occurence", ascending: false).first!
        
        
    }
    
    
}
