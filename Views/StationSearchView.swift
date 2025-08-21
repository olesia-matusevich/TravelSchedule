import SwiftUI

struct StationSearchView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var stationsVM: StationsViewModel
    
    @StateObject var viewModel: StationSearchViewModel
    let isSelectingFrom: Bool
    
    init(viewModel: StationSearchViewModel, isSelectingFrom: Bool) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isSelectingFrom = isSelectingFrom
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(
                searchText: Binding(
                    get: { viewModel.searchText },
                    set: { viewModel.updateQuery($0) }
                )
            )
            .padding(.vertical, 8)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredStations, id: \.self) { station in
                        Button {
                            if isSelectingFrom {
                                stationsVM.selectedFromStation = station
                            } else {
                                stationsVM.selectedToStation = station
                            }
                            navigationManager.resetToRoot()
                        } label: {
                            HStack {
                                Text(station.title ?? "(Нет названия)")
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
        .navigationTitle("Станции \(viewModel.settlement.title ?? "(Нет названия)")")
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
            if viewModel.filteredStations.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.customBlack)
            }
        }
        .task { viewModel.load() }
    }
}

