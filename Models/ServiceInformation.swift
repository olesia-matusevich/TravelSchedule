import Foundation

struct ServiceInformation: Identifiable, Sendable, Hashable {
    let id = UUID()
    let departureTime: String
    let arrivalTime: String
    let carrierCode: String
    let imageURL: URL?
    let carrierTitle: String
    let isTransfer: Bool
    let transferStation: String?
    let journeyTime: Int
    let date: String
}
