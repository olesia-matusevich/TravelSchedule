import SwiftUI
import OpenAPIURLSession

final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    func resetToRoot() { path = NavigationPath() }
}

enum Destination: Hashable {
    case citySearch(isSelectingFrom: Bool)
    case stationSearch(city: Components.Schemas.Settlement, isSelectingFrom: Bool)
    case carrierList(from: Components.Schemas.Station, to: Components.Schemas.Station)
    case carrierDetail(code: String)
    case filter(carrierVM: CarrierListViewModel)
    
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        switch (lhs, rhs) {
        case (.citySearch(let a), .citySearch(let b)):
            return a == b
        case (.stationSearch(let cityA, let isFromA), .stationSearch(let cityB, let isFromB)):
            return cityA == cityB && isFromA == isFromB
        case (.carrierList(let fromA, let toA), .carrierList(let fromB, let toB)):
            return fromA == fromB && toA == toB
        case (.carrierDetail(let codeA), .carrierDetail(let codeB)):
            return codeA == codeB
        case (.filter(let vmA), .filter(let vmB)):
            return ObjectIdentifier(vmA) == ObjectIdentifier(vmB) 
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .citySearch(let isFrom):
            hasher.combine("citySearch")
            hasher.combine(isFrom)
        case .stationSearch(let city, let isFrom):
            hasher.combine("stationSearch")
            hasher.combine(city)
            hasher.combine(isFrom)
        case .carrierList(let from, let to):
            hasher.combine("carrierList")
            hasher.combine(from)
            hasher.combine(to)
        case .carrierDetail(let code):
            hasher.combine("carrierDetail")
            hasher.combine(code)
        case .filter(let vm):
            hasher.combine("filter")
            hasher.combine(ObjectIdentifier(vm))
        }
    }
}
