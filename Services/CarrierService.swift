//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 22/07/2025.
//
import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(
        code: String
    ) async throws -> CarrierResponse
}

final class CarrierService: CarrierServiceProtocol {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(apikey: apiKey, code: code))
        
        print("TEST CarrierService:")
        print(try response.ok.hashValue)
        
        return try response.ok.body.json
    }
    
}
