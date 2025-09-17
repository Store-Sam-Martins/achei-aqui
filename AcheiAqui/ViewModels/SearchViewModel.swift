//
//  SearchViewModel.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import Foundation
import MapKit
import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var selectedTypes: Set<PlaceType> = [.supermercado, .farmacia, .shopping, .lanchonete, .restaurante, .bar]
    @Published var cep: String = ""
    @Published var isSearching = false
    @Published var results: [MKMapItem] = []
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -14.2350, longitude: -51.9253),
        span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
    )

    private let radiusMeters: CLLocationDistance = 25_000

    func setCenter(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radiusMeters * 2, longitudinalMeters: radiusMeters * 2)
    }

    func geocodeCEPAndSearch() async {
        let trimmed = cep.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isSearching = true
        defer { isSearching = false }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "\(trimmed), Brazil"
        request.resultTypes = .address
        request.region = MKCoordinateRegion(center: region.center, latitudinalMeters: radiusMeters * 2, longitudinalMeters: radiusMeters * 2)

        do {
            let search = MKLocalSearch(request: request)
            let response = try await search.start()

            // Use placemark.location (optional) instead of a non-optional property
            if let first = response.mapItems.first,
               let location = first.placemark.location {
                let coordinate = location.coordinate
                await MainActor.run { setCenter(coordinate) }
                try? await searchAround(center: coordinate)
            }
        } catch {
            print("Geocode (MKLocalSearch) error: \(error.localizedDescription)")
        }
    }

    func searchUsingCurrentLocation(_ coordinate: CLLocationCoordinate2D) async {
        isSearching = true
        defer { isSearching = false }
        await MainActor.run { setCenter(coordinate) }
        try? await searchAround(center: coordinate)
    }

    @MainActor
    func openDirections(to item: MKMapItem, transportType: MKDirectionsTransportType = .automobile) {
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: transportType == .automobile ? MKLaunchOptionsDirectionsModeDriving : MKLaunchOptionsDirectionsModeWalking
        ]
        item.openInMaps(launchOptions: launchOptions)
    }

    private func searchAround(center: CLLocationCoordinate2D) async throws {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: radiusMeters * 2, longitudinalMeters: radiusMeters * 2)
        var aggregated: [MKMapItem] = []
        let types = Array(selectedTypes)

        for type in types {
            if let query = type.fallbackQuery {
                let req = MKLocalSearch.Request()
                req.naturalLanguageQuery = query
                req.region = region
                let resp = try await MKLocalSearch(request: req).start()
                aggregated.append(contentsOf: resp.mapItems)
            }
        }

        let centerLoc = CLLocation(latitude: center.latitude, longitude: center.longitude)
        var seen = Set<String>()
        let filtered = aggregated.compactMap { item -> MKMapItem? in
            guard let loc = item.placemark.location else { return nil }
            let coordinate = loc.coordinate
            let dist = loc.distance(from: centerLoc)
            guard dist <= radiusMeters else { return nil }
            let key = "\(item.name ?? "?")_\(coordinate.latitude.rounded(to: 6))_\(coordinate.longitude.rounded(to: 6))"
            if seen.contains(key) { return nil }
            seen.insert(key)
            return item
        }

        await MainActor.run {
            let sorted = filtered.sorted { a, b in
                let da = a.placemark.location?.distance(from: centerLoc) ?? .greatestFiniteMagnitude
                let db = b.placemark.location?.distance(from: centerLoc) ?? .greatestFiniteMagnitude
                return da < db
            }
            self.results = sorted
            self.region = region
        }
    }
}

private extension Double {
    func rounded(to places: Int) -> Double {
        let p = pow(10.0, Double(places))
        return (self * p).rounded() / p
    }
}
