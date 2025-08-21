import Foundation
import OpenAPIURLSession

actor ApiClient {
    private let client: Client
    private let apiKey: String
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func search(from: String, to: String) async throws -> [ServiceInformation] {
        let service = SearchService(apiKey: apiKey, client: client)
        return try await service.search(from: from, to: to)
    }
    
    func getAllStations() async throws -> AllStationsResponse? {
        let service = StationsListService(apiKey: apiKey, client: client)
        return try await service.getAllStations()
    }
    
    func getFilteredCities() async throws -> [Components.Schemas.Settlement] {
        let service = StationsListService(apiKey: apiKey, client: client)
        return try await service.getFilteredCities()
    }
}

extension ApiClient {
    var rawClient: Client { client }
    var key: String { apiKey }
}
