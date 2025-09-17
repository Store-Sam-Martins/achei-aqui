//
//  LocationManager.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentCoordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestWhenInUse() {
        #if os(iOS) || os(tvOS) || os(watchOS)
        manager.requestWhenInUseAuthorization()
        #elseif os(macOS)
        // On macOS, requestAlwaysAuthorization is used; when-in-use is not available.
        if manager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
            manager.requestAlwaysAuthorization()
        }
        #endif
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        #if os(iOS) || os(tvOS) || os(watchOS)
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startUpdating()
        }
        #elseif os(macOS)
        if authorizationStatus == .authorized {
            startUpdating()
        }
        #endif
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentCoordinate = loc.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
