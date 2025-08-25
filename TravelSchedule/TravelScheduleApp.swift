import SwiftUI
import OpenAPIURLSession

@main
struct TravelScheduleApp: App {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var stationsVM: StationsViewModel
    @StateObject private var settingsVM = SettingsViewModel()
    
    private let apiClient: ApiClient
    
    init() {
        let client = ApiClient(
            apiKey: apiKey,
            client: Client(
                serverURL: try! Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        )
        self.apiClient = client
        _stationsVM = StateObject(wrappedValue: StationsViewModel(apiClient: client))
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $navigationManager.path) {
                    MainView(stationsVM: stationsVM) 
                        .environmentObject(navigationManager)
                        .environmentObject(stationsVM)
                        .navigationDestination(for: Destination.self) { dest in
                            switch dest {
                            case .citySearch(let isFrom):
                                CitySearchView(
                                    viewModel: CitySearchViewModel(apiClient: apiClient),
                                    isSelectingFrom: isFrom
                                )
                                .environmentObject(navigationManager)
                                .environmentObject(stationsVM)
                                
                            case .stationSearch(let city, let isFrom):
                                StationSearchView(
                                    viewModel: StationSearchViewModel(settlement: city),
                                    isSelectingFrom: isFrom
                                )
                                .environmentObject(navigationManager)
                                .environmentObject(stationsVM)
                                
                            case .carrierList(let from, let to):
                                let carrierVM = CarrierListViewModel(apiClient: apiClient, from: from, to: to)
                                CarrierListView(viewModel: carrierVM)
                                    .environmentObject(navigationManager)
                                    .environmentObject(carrierVM)
                                
                            case .carrierDetail(let code):
                                TransportDetailView(
                                    viewModel: TransportDetailViewModel(
                                        carrierService: CarrierService(apiKey: apiKey, client: apiClient.rawClient),
                                        code: code
                                    )
                                )
                                .environmentObject(navigationManager)
                                
                            case .filter(let carrierVM):
                                FilterView(viewModel: FilterViewModel(initialFilters: carrierVM.filters))
                                    .environmentObject(navigationManager)
                                    .environmentObject(carrierVM)
                            }
                        }
                }
                .tabItem {
                    Image("schedule_tab_ic").renderingMode(.template)
                }
                .tag(0)
                
                SettingsView()
                    .environmentObject(settingsVM)
                    .tabItem {
                        Image("settings_tab_ic").renderingMode(.template)
                    }
            }
            .environment(\.apiClient, apiClient)
            .environmentObject(stationsVM)
            .environmentObject(navigationManager)
            .preferredColorScheme(settingsVM.isDarkMode ? .dark : .light)
            .task { await stationsVM.loadCitiesIfNeeded() }
        }
    }
}


