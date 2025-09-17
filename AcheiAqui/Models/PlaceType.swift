//
//  PlaceType.swift
//  AcheiAqui
//
//  Created by Silvanei Martins on 17/09/25.
//
import MapKit

enum PlaceType: String, CaseIterable, Identifiable {
    case supermercado = "Supermercados"
    case farmacia = "Farmácias"
    case shopping = "Shoppings"
    case lanchonete = "Lanchonetes"
    case restaurante = "Restaurantes"
    case bar = "Bares"
    case outros = "Outros"

    var id: String { rawValue }

    var categories: [MKPointOfInterestCategory]? {
        switch self {
        case .supermercado: return [.store]
        case .farmacia: return [.pharmacy]
        case .shopping: return [.store]
        case .lanchonete: return [.cafe]
        case .restaurante: return [.restaurant]
        case .bar: return [.nightlife]
        case .outros: return nil
        }
    }

    var fallbackQuery: String? {
        switch self {
        case .supermercado: return "supermercado"
        case .farmacia: return "farmácia"
        case .shopping: return "shopping"
        case .lanchonete: return "lanchonete"
        case .restaurante: return "restaurante"
        case .bar: return "bar"
        case .outros: return nil
        }
    }
}
