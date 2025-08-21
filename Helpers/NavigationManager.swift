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
    case filter
}

