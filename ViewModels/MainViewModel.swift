import Foundation
import OpenAPIURLSession

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var storiesVM = StoriesViewModel()
    
    let stationsVM: StationsViewModel
    
    init(stationsVM: StationsViewModel) {
        self.stationsVM = stationsVM
    }
    
    func swapStations() {
        let from = stationsVM.selectedFromStation
        let to = stationsVM.selectedToStation
        stationsVM.selectedFromStation = to
        stationsVM.selectedToStation = from
    }
}

