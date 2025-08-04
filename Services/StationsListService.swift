//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 22/07/2025.
//
import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse?
}

final class StationsListService: StationsListServiceProtocol {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getAllStations() async throws -> AllStationsResponse? {
        
        do {
            let response = try await client.getAllStations(query: .init(apikey: apiKey, transportType: "train"))
            
            let responseBody = try response.ok.body.html
            print(try response.ok.hashValue)
            let limit = 50 * 1024 * 1024
            let fullData = try await Data(collecting: responseBody, upTo: limit)
            
            let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)
            return allStations
            
        } catch {
            if error is OpenAPIRuntime.ClientError {
                print("Client error: \(error)")
                throw ErrorViewType.networkError
            } else {
                print("Server error: \(error)")
                throw ErrorViewType.serverError
            }
            
        }
    }
    
    func getFilteredCities() async throws -> [Components.Schemas.Settlement] {
        let response = try await getAllStations()
       
        
        guard let countries = response?.countries else {
            return []
        }
        
        if let russia = countries.first(where: { $0.title == "Россия" }),
           let regions = russia.regions {
            let targetRegions = ["Москва и Московская область", "Санкт-Петербург и Ленинградская область", "Краснодарский край"]
            let filteredRegions = regions.filter { region in
                targetRegions.contains(region.title ?? "")
            }
            let allSettlements = filteredRegions.flatMap { $0.settlements ?? [] }
            
            // Фильтруем города, у которых title не nil и не пустой, затем сортируем по алфавиту
            let validSettlements = allSettlements.filter { city in
                if let title = city.title {
                    return !title.isEmpty
                }
                return false
            }
            return validSettlements.sorted { $0.title! < $1.title! }
        }
        
        return []
    }
}
