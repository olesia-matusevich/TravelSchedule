
import SwiftUI
import OpenAPIURLSession

enum Destination: Hashable {
    case citySearch(isSelectingFrom: Bool)
    case stationSearch(city: Components.Schemas.Settlement, isSelectingFrom: Bool)
    case carrierList(from: Components.Schemas.Station, to: Components.Schemas.Station)
    case carrierDetail
    case filter
}

@main
struct TravelScheduleApp: App {
    @StateObject private var viewModel = StationsViewModel(apiKey: apiKey)
    @StateObject private var navigationManager = NavigationManager()
    
    @State private var selectedFromStation: Components.Schemas.Station? = nil
    @State private var selectedToStation: Components.Schemas.Station? = nil
    
    private let tabItemSize: Double = 30
    
    private func setupAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $navigationManager.path) {
                    MainView(
                        selectedFromStation: $selectedFromStation,
                        selectedToStation: $selectedToStation
                    )
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .citySearch(let isSelectingFrom):
                            CitySearchView(
                                isSelectingFrom: isSelectingFrom
                            )
                            .environmentObject(viewModel)
                            .environmentObject(navigationManager)
                        case .stationSearch(let city, let isSelectingFrom):
                            StationSearchView(
                                selectedFromStation: $selectedFromStation,
                                selectedToStation: $selectedToStation,
                                selectedSettlement: city,
                                isSelectingFrom: isSelectingFrom
                            )
                            .environmentObject(viewModel)
                            .environmentObject(navigationManager)
                        case .carrierList(let from, let to):
                            CarrierListView(
                                fromStation: from,
                                toStation: to
                            )
                            .environmentObject(viewModel)
                            .environmentObject(navigationManager)
                        case .carrierDetail:
                            TransportDetailView()
                        case .filter:
                            FilterView()
                        }
                    }
                }
                .tabItem {
                    Image("schedule_tab_ic")
                        .renderingMode(.template)
                        .frame(width: tabItemSize, height: tabItemSize)
                }
                .tag(0)
                SettingsView()
                    .tabItem {
                        Image("settings_tab_ic")
                            .renderingMode(.template)
                            .frame(width: tabItemSize, height: tabItemSize)
                    }
                    .tag(1)
            }
            .tint(.customBlack)
            .environmentObject(viewModel)
            .environmentObject(navigationManager)
            .onAppear {
                setupAppearance()
            }
            .task {
                await viewModel.loadCities()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
