//
//  NearestStationsService.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 22/07/2025.
//
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestStations = Components.Schemas.Stations

protocol NearestStationsServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations
}

final class NearestStationsService: NearestStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(apiKey: String, client: Client) {
        self.client = client
        self.apikey = apiKey
    }
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        
        let response = try await client.getNearestStations(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        
        print("TEST NearestStationsService:")
        print(try response.ok.hashValue)
        
        return try response.ok.body.json
    }
}
