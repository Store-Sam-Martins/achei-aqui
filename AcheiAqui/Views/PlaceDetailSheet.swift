//
//  PlaceDetailSheet.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import SwiftUI
import MapKit

struct PlaceDetailSheet: View {
    let item: MKMapItem
    @EnvironmentObject var vm: SearchViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.name ?? "Local")
                .font(.title2).bold()

            if let address = item.placemark.title {
                Text(address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let phone = item.phoneNumber {
                Link(destination: URL(string: "tel:\(phone)")!) {
                    Label(phone, systemImage: "phone.fill")
                }
            }

            if let url = item.url {
                Link("Site", destination: url)
            }

            Spacer()

            HStack {
                Button {
                    vm.openDirections(to: item, transportType: .automobile)
                } label: {
                    Label("Rotas de carro", systemImage: "car.fill")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    vm.openDirections(to: item, transportType: .walking)
                } label: {
                    Label("A pé", systemImage: "figure.walk")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}
