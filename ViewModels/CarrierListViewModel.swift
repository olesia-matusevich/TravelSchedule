import Foundation

@MainActor
final class CarrierListViewModel: ObservableObject {
    
    @Published var items: [ServiceInformation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var errorType: ErrorViewType?
    
    @Published var filters = Filters()
    
    private let apiClient: ApiClient
    let from: Components.Schemas.Station
    let to: Components.Schemas.Station
    
    init(apiClient: ApiClient, from: Components.Schemas.Station, to: Components.Schemas.Station) {
        self.apiClient = apiClient
        self.from = from
        self.to = to
    }
    
    var filteredItems: [ServiceInformation] {
        items.filter { service in
            if filters.ranges.contains(where: { $0.value }) {
                guard let depHour = Int(service.departureTime.prefix(2)) else { return false }
                var inRange = false
                if filters.ranges["Утро 06:00 - 12:00"] == true {
                    inRange = inRange || (6..<12).contains(depHour)
                }
                if filters.ranges["День 12:00 - 18:00"] == true {
                    inRange = inRange || (12..<18).contains(depHour)
                }
                if filters.ranges["Вечер 18:00 - 00:00"] == true {
                    inRange = inRange || (18..<24).contains(depHour)
                }
                if filters.ranges["Ночь 00:00 - 06:00"] == true {
                    inRange = inRange || (0..<6).contains(depHour)
                }
                if !inRange { return false }
            }
            if let transferFilter = filters.showTransferRaces {
                if service.isTransfer != transferFilter { return false }
            }
            return true
        }
    }
    
    func load() async {
        isLoading = true; defer { isLoading = false }
        do {
            let fromCode = from.codes?.yandex_code ?? ""
            let toCode = to.codes?.yandex_code ?? ""
            items = try await apiClient.search(from: fromCode, to: toCode)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            items = []
        }
    }
}

struct Filters {
    var ranges: [String: Bool] = [
        "Утро 06:00 - 12:00": false,
        "День 12:00 - 18:00": false,
        "Вечер 18:00 - 00:00": false,
        "Ночь 00:00 - 06:00": false
    ]
    var showTransferRaces: Bool? = nil
}
