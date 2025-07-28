//
//  NearestSettlementService.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 22/07/2025.
//
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestSettlementServiceProtocol {
    func getNearestCity(
        lat: Double,
        lng: Double
    ) async throws -> NearestCityResponse
}

final class NearestSettlementService: NearestSettlementServiceProtocol {
    
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(query: .init(apikey: apiKey, lat: lat, lng: lng))
        
        print("TEST NearestSettlementService:")
        print(try response.ok.hashValue)
        
        return try response.ok.body.json
    }
}
