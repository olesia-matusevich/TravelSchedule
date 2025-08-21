import Foundation

@MainActor
final class StationSearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var filteredStations: [Components.Schemas.Station] = []
    
    let settlement: Components.Schemas.Settlement
    
    init(settlement: Components.Schemas.Settlement) {
        self.settlement = settlement
        applyFilter()
    }
    
    func load() { applyFilter() }
    func updateQuery(_ q: String) { searchText = q; applyFilter() }
    
    private func applyFilter() {
        let list = settlement.stations ?? []
        let base = searchText.isEmpty ? list : list.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
        filteredStations = base.filter {
            $0.transport_type == "train" && (($0.title ?? "").isEmpty == false) }
        .sorted { ($0.title ?? "") < ($1.title ?? "")
        }
    }
}


