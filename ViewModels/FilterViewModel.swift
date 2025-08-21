import Foundation

@MainActor
final class FilterViewModel: ObservableObject {
    
    @Published var ranges: [String: Bool] = [
        "Утро 06:00 - 12:00": false,
        "День 12:00 - 18:00": false,
        "Вечер 18:00 - 00:00": false,
        "Ночь 00:00 - 06:00": false
    ]
    @Published var showTransferRaces: Bool = false
    
    func toggleRange(_ key: String) {
        ranges[key]?.toggle()
    }
}


