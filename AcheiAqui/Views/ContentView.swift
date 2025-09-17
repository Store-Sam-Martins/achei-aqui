//
//  ContentView.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var vm: SearchViewModel

    @State private var selectedItem: MKMapItem?
    @State private var showSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ControlsBar()
                    .padding(.horizontal)
                    .padding(.top)

                ZStack(alignment: .bottom) {
                    Map(initialPosition: .region(vm.region)) {
                        ForEach(vm.results, id: \.self) { item in
                            if let coord = item.placemark.location?.coordinate {
                                Annotation(item.name ?? "Local", coordinate: coord) {
                                    Button {
                                        selectedItem = item
                                        showSheet = true
                                    } label: {
                                        Image(systemName: "mappin.circle.fill")
                                            .imageScale(.large)
                                    }
                                }
                            }
                        }
                    }

                    if vm.isSearching {
                        ProgressView("Buscando locais…")
                            .padding(8)
                            .background(.ultraThinMaterial, in: Capsule())
                            .padding(.bottom, 12)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationTitle("Locais por Perto")
            .toolbar {
                #if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let coord = locationManager.currentCoordinate {
                            // Centraliza no usuário (ajusta o mapa)
                            vm.setCenter(coord)
                        } else {
                            // Pede permissão e começa a atualizar a localização
                            locationManager.requestWhenInUse()
                            locationManager.startUpdating()
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }
                    .accessibilityLabel("Localizar minha posição")
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button {
                        if let coord = locationManager.currentCoordinate {
                            // Centraliza no usuário (ajusta o mapa)
                            vm.setCenter(coord)
                        } else {
                            // Pede permissão e começa a atualizar a localização
                            locationManager.requestWhenInUse()
                            locationManager.startUpdating()
                        }
                    } label: {
                        Image(systemName: "location.circle.fill")
                    }
                    .accessibilityLabel("Localizar minha posição")
                }
                #endif
            }
            .sheet(isPresented: $showSheet) {
                if let item = selectedItem {
                    PlaceDetailSheet(item: item)
                }
            }
        }
        .task {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestWhenInUse()
            }
        }
    }
}
