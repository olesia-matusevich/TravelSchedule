import SwiftUI

struct CitySearchView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject var viewModel: CitySearchViewModel
    let isSelectingFrom: Bool
    
    init(viewModel: CitySearchViewModel, isSelectingFrom: Bool) {
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
                    ForEach(viewModel.results, id: \.self) { city in
                        Button {
                            navigationManager.path.append(Destination.stationSearch(city: city, isSelectingFrom: isSelectingFrom))
                        } label: {
                            HStack {
                                Text(city.title ?? "(Нет названия)").padding(.leading, 16)
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(.customBlack)
                                    .padding(.trailing, 18)
                            }.frame(height: 60)
                        }.buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Выбор города")
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
            if !viewModel.isLoading && viewModel.results.isEmpty {
                Text("Город не найден")
                    .font(.system(size:24))
                    .fontWeight(.bold)
                    .foregroundColor(.customBlack)
            }
        }
        .task { await viewModel.load() }
    }
}

