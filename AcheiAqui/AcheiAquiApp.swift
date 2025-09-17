//
//  AcheiAquiApp.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import SwiftUI

@main
struct PlacesApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = SearchViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(vm)
        }
    }
}
