//
//  ControlsBar.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import SwiftUI

struct ControlsBar: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var vm: SearchViewModel

    var body: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(PlaceType.allCases) { type in
                        let isOn = vm.selectedTypes.contains(type)
                        Button {
                            if isOn { vm.selectedTypes.remove(type) }
                            else { vm.selectedTypes.insert(type) }
                        } label: {
                            Text(type.rawValue)
                                .font(.caption)
                                .padding(8)
                                .background(isOn ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.2))
                                .clipShape(Capsule())
                        }
                    }
                }
            }

            HStack(spacing: 8) {
                TextField("Digite um CEP", text: $vm.cep)
                    .textContentType(.postalCode)
#if os(iOS)
                    .keyboardType(UIKeyboardType.numbersAndPunctuation)
#endif
                    .submitLabel(SubmitLabel.search)
                    .onSubmit { Task { await vm.geocodeCEPAndSearch() } }
                    .padding(10)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Button("Buscar CEP") { Task { await vm.geocodeCEPAndSearch() } }
                    .buttonStyle(.bordered)

                Button("Perto de mim") {
                    if let coord = locationManager.currentCoordinate {
                        Task { await vm.searchUsingCurrentLocation(coord) }
                    } else {
                        locationManager.requestWhenInUse()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

