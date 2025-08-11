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
        
        VStack(spacing: 0) {
            SearchBar(searchText: $searchText)
                .padding(.top, 8)
                .padding(.bottom, 8)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredCities, id: \.self) { city in
                        Button(action: {
                            self.hideKeyboard()
                            navigationManager.path.append(Destination.stationSearch(city: city, isSelectingFrom: isSelectingFrom))
                        }) {
                            HStack(alignment: .center) {
                                Text(city.title ?? "(Нет названия)")
                                    .font(.system(size: 17))
                                    .padding(.leading, 16)
                                
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
            if filteredCities.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.customBlack)
            }
        }
    }
}
