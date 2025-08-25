import Foundation

@MainActor
final class StationsViewModel: ObservableObject {
    @Published var allCities: [Components.Schemas.Settlement] = []
    @Published var isLoading: Bool = false
    @Published var errorType: ErrorViewType? = nil
    
    @Published var selectedFromStation: Components.Schemas.Station?
    @Published var selectedToStation: Components.Schemas.Station?
    
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func selectStation(_ station: Components.Schemas.Station, isFrom: Bool) {
        if isFrom {
            selectedFromStation = station
        } else {
            selectedToStation = station
        }
    }
    
    func swapStations() {
           let from = selectedFromStation
           selectedFromStation = selectedToStation
           selectedToStation = from
       }
    
    func loadCitiesIfNeeded() async {
        guard !isLoading, allCities.isEmpty else { return }
        await loadCities()
    }
    
    func loadCities() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let cities = try await apiClient.getFilteredCities()
            allCities = cities
            errorType = nil
        } catch let e as ErrorViewType {
            errorType = e
        } catch {
            errorType = .serverError
        }
    }
}

