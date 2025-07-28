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
    func getAllStations() async throws -> AllStationsResponse
}

final class StationsListService: StationsListServiceProtocol {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getAllStations() async throws -> AllStationsResponse {
        let response = try await client.getAllStations(query: .init(apikey: apiKey, transportType: "train"))
        
        let responseBody = try response.ok.body.html
        print(try response.ok.hashValue)
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        
        let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)
        
        print("TEST StationsListService:")
        print(try response.ok.hashValue)
        
        return allStations
    }
}
