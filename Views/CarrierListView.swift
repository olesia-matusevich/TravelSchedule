import SwiftUI
import OpenAPIURLSession


struct CarrierListView: View {
    
    @EnvironmentObject private var viewModel: StationsViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    let fromStation: Components.Schemas.Station
    let toStation: Components.Schemas.Station
    
    private var searchService: SearchService
    @State private var isFiltered: Bool = false
    @State private var segments: [Components.Schemas.Segment] = []
    @State private var errorMessage: String?
    @State private var serviceInformations: [ServiceInformation] = []
    
    @State private var isLoading: Bool = false
    
    init(fromStation: Components.Schemas.Station, toStation: Components.Schemas.Station) {
        self.fromStation = fromStation
        self.toStation = toStation
        self.searchService = SearchService(
            apiKey: apiKey,
            client: Client(
                serverURL: try! Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        )
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
            } else {
                Text("\(fromStation.title ?? "Откуда") → \(toStation.title ?? "Куда")")
                    .font(.system(size: 24))
                    .bold()
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                List(serviceInformations, id: \.self) { service in
                    Button(action: {
                        navigationManager.path.append(Destination.carrierDetail)
                    }) {
                        CarrierRow(serviceInfo: service)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
                    .background(.customWhite)
                }
                .listStyle(.plain)
            }
        }
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
           
            
            if serviceInformations.isEmpty, errorMessage == nil {
                Text("Вариантов нет")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.customBlack)
            } else if let error = errorMessage {
                Text(error)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
        }
        .overlay {
            Button(action: {
                navigationManager.path.append(Destination.filter)
            }) {
                Text("Уточнить время")
                    .font(.system(size: 17))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blueUniversal.cornerRadius(16))
                    .foregroundColor(.whiteUniversal)
                    .overlay(
                        Group {
                            if isFiltered {
                                Circle().fill(.redUniversal).frame(width: 8, height: 8)
                                    .offset(x: UIScreen.main.bounds.width / 5)
                            }
                        }
                    )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .onAppear {
            Task {
                isLoading = true
                await loadRaces()
                isLoading = false
            }
        }
    }
    
    private func loadRaces() async -> [ServiceInformation] {
        do {
            var result = try await searchService.search(
                from: fromStation.codes?.yandex_code ?? "",
                to: toStation.codes?.yandex_code ?? ""
            )
            errorMessage = nil
            serviceInformations = result
            return result
        } catch {
            errorMessage = "Ошибка загрузки рейсов: \(error.localizedDescription)"
            segments = []
            
        }
        return []
    }
}


