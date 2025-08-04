import SwiftUI
import OpenAPIURLSession

struct CitySearchView: View {

    @EnvironmentObject private var viewModel: StationsViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @State private var searchText: String = ""
   
    let isSelectingFrom: Bool
    
    var filteredCities: [Components.Schemas.Settlement] {
        let cities = searchText.isEmpty ? viewModel.allCities : viewModel.allCities.filter { city in
            city.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return cities
            .filter { $0.title != nil && !$0.title!.isEmpty }
            .sorted { $0.title! < $1.title! }
    }
    
    var body: some View {
        List(filteredCities, id: \.self) { city in
            Button(action: {
                navigationManager.path.append(Destination.stationSearch(city: city, isSelectingFrom: isSelectingFrom))
            }) {
                HStack {
                    Text(city.title ?? "(Нет названия)")
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
        .listStyle(.plain)
        .navigationTitle("Выбор города")
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
            
            if filteredCities.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.customBlack)
            }
        }
    }
    }
