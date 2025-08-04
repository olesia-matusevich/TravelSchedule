import SwiftUI
import OpenAPIURLSession
import OpenAPIRuntime
import Combine

class StationsViewModel: ObservableObject {
    @Published var allCities: [Components.Schemas.Settlement] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var errorType: ErrorViewType?
    
    private let stationsService: StationsListService
    
    init(apiKey: String) {
        self.stationsService = StationsListService(
            apiKey: apiKey,
            client: Client(
                serverURL: try! Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        )
    }
    
    func loadCities()  {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        Task {
            do {
                let allCities = try await stationsService.getFilteredCities()
                
                let filteredCities = allCities.filter { settlement in
                    guard let stations = settlement.stations else { return false }
                    return stations.contains { $0.transport_type == "train" }
                }
                await MainActor.run {
                    self.allCities = filteredCities
                    self.isLoading = false
                    errorType = nil
                }
            } catch let error as ErrorViewType {
                errorType = error
            } catch {
                errorType = .serverError
            }
       }
    }
}
