//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 22/07/2025.
//
import OpenAPIRuntime
import OpenAPIURLSession

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyrightInfo() async throws -> CopyrightResponse
}

final class CopyrightService: CopyrightServiceProtocol {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getCopyrightInfo() async throws -> CopyrightResponse {
        let response = try await client.getCopyrightInfo(query: .init(apikey: apiKey))
        
        print("TEST CopyrightService:")
        print(try response.ok.hashValue)
        
        return try response.ok.body.json
    }
}
