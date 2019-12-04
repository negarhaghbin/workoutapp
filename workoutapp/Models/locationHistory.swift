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
    let locationManager = CLLocationManager()
    
    func set(lat: Double, long: Double) {
        self.latitude=lat
        self.longitude=long
    }
    
    func add(){
        let allRegions = getAllRegions()
        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        print("hereeeeee")
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Make sure region monitoring is supported.
            print("in ifff")
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
                for r in allRegions {
                    if (r.contains(center)){
                        increaseOccurence(r: r)
                        return
                    }
                }
                addNew()
            }
        }
    }
    
    func increaseOccurence(r: CLCircularRegion){
        let realm = try? Realm()
        var specificLocation = realm!.objects(location.self).filter("latitude == \(r.center.latitude) && longitude == \(r.center.longitude)").first
        try! realm?.write {
            specificLocation!.occurence += 1
        }
        print(specificLocation as Any)
        
    }
    
    func getRegion()->CLCircularRegion{
        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let maxDistance = locationManager.maximumRegionMonitoringDistance
        //find the best radius**********************
        return CLCircularRegion(center: center, radius: 10.0, identifier: "")
    }
    
    func getAllRegions()->[CLCircularRegion]{
        let realm = try? Realm()
        let locations = Array(realm!.objects(location.self))
        var results : [CLCircularRegion] = []
        
        for location in locations {
            results.append(location.getRegion())
        }
        return results
    }
    
    func addNew(){
        let realm = try? Realm()
        try! realm?.write {
            realm!.add(location(value: [self.latitude, self.longitude, Int(1)]))
        }
    }
    
    class func getMostRecordedLocation()->location{
        let realm = try? Realm()
        return realm!.objects(location.self).sorted(byKeyPath: "occurence", ascending: false).first!
        
    }
    
    
}
