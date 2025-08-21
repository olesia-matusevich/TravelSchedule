import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

struct CarrierInfo: Sendable {
    let title: String
    let email: String
    let phoneNumber: String
    let imageURL: URL?
}

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(
        code: String
    ) async throws -> CarrierInfo
}

final class CarrierService: CarrierServiceProtocol {
    
    
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
   
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        do {
            let response = try await client.getCarrier(query: .init(apikey: apiKey, code: code))
            let carrierResponse = try response.ok.body.json
            
            var imageURL: URL? = nil
            if let logoString = carrierResponse.carrier?.logo, !logoString.isEmpty {
                imageURL = URL(string: logoString)
            }
            
            let carrierInfo: CarrierInfo = CarrierInfo(
                title: carrierResponse.carrier?.title ?? "",
                email: carrierResponse.carrier?.email ?? "",
                phoneNumber: carrierResponse.carrier?.phone ?? "",
                imageURL: imageURL
            )
            
            return carrierInfo
            
        }catch {
            if error is OpenAPIRuntime.ClientError {
                print("Client error: \(error)")
                throw ErrorViewType.networkError
            } else {
                print("Server error: \(error)")
                throw ErrorViewType.serverError
            }
        }
    }
    
}
