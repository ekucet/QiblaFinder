//
//  ContentView.swift
//  Compass
//
//  Created by Erkam Kucet on 2.05.2020.
//  Copyright © 2020 ekucet. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @ObservedObject var compassHeading = CompassHeading()
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 5, height: 50)
            ZStack {
                ForEach(Marker.markers(), id: \.self) { marker in
                    CompassMarkerView(marker: marker,
                                      compassDegress: 0)
                }
            }
            .frame(width: 300,  height: 300)
            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
            .statusBar(hidden: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import Combine
import CoreLocation

class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
   
    var objectWillChange = PassthroughSubject<Void, Never>()
    var degrees: Double = .zero {
        didSet{
            objectWillChange.send()
        }
    }
    
    private var bearingOfKabah = Double()
    private let locationManager = CLLocationManager()
    private let locationOfKabah = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.headingAvailable() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let north = -1 * newHeading.magneticHeading * Double.pi / 180
        let directionOfKabah = bearingOfKabah * Double.pi / 180 + north
        self.degrees = radiansToDegrees(directionOfKabah)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            bearingOfKabah = getBearingOfKabah(currentLocation: location, locationOfKabah: locationOfKabah)
        }
    }
    
    private func degreesToRadians(_ deg: Double) -> Double {
        return deg * Double.pi / 180
    }
    
    private func radiansToDegrees(_ rad: Double) -> Double {
        return rad * 180 / Double.pi
    }
    
    private func getBearingOfKabah(currentLocation: CLLocation, locationOfKabah: CLLocation) -> Double {
        let currentLatitude = degreesToRadians(currentLocation.coordinate.latitude)
        let currentLongitude = degreesToRadians(currentLocation.coordinate.longitude)
        
        let latitudeOfKabah = degreesToRadians(locationOfKabah.coordinate.latitude)
        let longitudeOfKabah = degreesToRadians(locationOfKabah.coordinate.longitude)
        
        let dLongitude = longitudeOfKabah - currentLongitude
        
        let y = sin(dLongitude) * cos(latitudeOfKabah)
        let x = cos(currentLatitude) - sin(latitudeOfKabah) - sin(currentLatitude) * cos(latitudeOfKabah) - cos(dLongitude)
        
        var radiansBearing = atan2(y, x)
        
        if radiansBearing < 0.0 {
            radiansBearing += 2 * Double.pi
        }
        
        return radiansToDegrees(radiansBearing)
    }
}
