import Foundation
import SwiftUI

@MainActor
final class FilterViewModel: ObservableObject {
    
    @Published var ranges: [String: Bool] = [
        "Утро 06:00 - 12:00": false,
        "День 12:00 - 18:00": false,
        "Вечер 18:00 - 00:00": false,
        "Ночь 00:00 - 06:00": false
    ]
    @Published var showTransferRaces: Bool = false
    
    init(initialFilters: Filters = Filters()) {
        self.ranges = initialFilters.ranges
        self.showTransferRaces = initialFilters.showTransferRaces ?? false
    }
    
    func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { self.ranges[key, default: false] },
            set: { self.ranges[key] = $0 }
        )
    }
    
    var filters: Filters {
        Filters(ranges: ranges, showTransferRaces: showTransferRaces)
    }
    
    func toggleRange(_ key: String) {
        ranges[key]?.toggle()
    }
}


