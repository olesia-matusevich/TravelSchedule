import SwiftUI
import OpenAPIURLSession

struct StationSearchView: View {
    
    @EnvironmentObject private var viewModel: StationsViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @Binding var selectedFromStation: Components.Schemas.Station?
    @Binding var selectedToStation: Components.Schemas.Station?
    
    let selectedSettlement: Components.Schemas.Settlement
    let isSelectingFrom: Bool
    
    @State private var searchText: String = ""
    
    var filteredStations: [Components.Schemas.Station] {
        let stations = searchText.isEmpty ? (selectedSettlement.stations ?? []) : (selectedSettlement.stations ?? []).filter { station in
            station.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return Array(stations)
            .filter { $0.transport_type == "train" }
            .filter { $0.title != nil && !$0.title!.isEmpty }
            .sorted { $0.title! < $1.title! }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(searchText: $searchText)
                .padding(.top, 8)
                .padding(.bottom, 8)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredStations, id: \.self) { station in
                        Button(action: {
                            self.hideKeyboard()
                            
                            if isSelectingFrom {
                                selectedFromStation = station
                            } else {
                                selectedToStation = station
                            }
                            navigationManager.resetToRoot()
                        }) {
                            HStack(alignment: .center) {
                                Text(station.title ?? "(Нет названия)")
                                    .font(.system(size: 17))
                                    .padding(.leading, 16)
                                    .foregroundColor(.customBlack)
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(.customBlack)
                                    .padding(.trailing, 18)
                            }
                            .frame(height: 60)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Станции \(selectedSettlement.title ?? "(Нет названия)")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.path.removeLast()
                }) {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.backward")
                    }
                }
                .foregroundColor(.customBlack)
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            if filteredStations.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.customBlack)
            }
        }
    }
}
