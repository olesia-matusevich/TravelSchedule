//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 22/07/2025.
//
import OpenAPIRuntime
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func search(from: String, to: String) async throws -> Segments
}

final class SearchService: SearchServiceProtocol {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func search(from: String, to: String) async throws -> Segments {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apiKey,
            from: from,
            to: to)
        )
        print("TEST SearchService:")
        print(try response.ok.hashValue)
        
        return try response.ok.body.json
    }
}
