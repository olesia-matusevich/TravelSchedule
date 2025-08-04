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
    @State private var isSearchActive: Bool = false
    
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
        List(filteredStations, id: \.self) { station in
            
            Button(action: {
                self.hideKeyboard()
        
                if isSelectingFrom {
                    selectedFromStation = station
                } else {
                    selectedToStation = station
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    navigationManager.resetToRoot()
                }
                
            }) {
                HStack {
                    Text(station.title ?? "(Нет названия)")
                        .padding(.vertical, 8)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .foregroundColor(.customBlack)
                }
            }
            .listRowSeparator(.hidden)
            .buttonStyle(.plain)
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Введите запрос")
        )
//        .focused($isSearchBarFocused)
        .listStyle(.plain)
        .navigationTitle("Станции \(selectedSettlement.title ?? "(Нет названия)")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 0) {
                    Button(action: {
                        navigationManager.path.removeLast()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.customBlack)
                    }
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            if filteredStations.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.blackDay)
            }
        }
    }
}
