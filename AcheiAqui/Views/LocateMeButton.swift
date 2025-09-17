//
//  LocateMeButton.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import SwiftUI

struct LocateMeButton: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var vm: SearchViewModel

    var body: some View {
        Button {
            if let coord = locationManager.currentCoordinate {
                withAnimation { vm.setCenter(coord) }
            } else {
                locationManager.requestWhenInUse()
            }
        } label: {
            Image(systemName: "scope")
        }
    }
}
