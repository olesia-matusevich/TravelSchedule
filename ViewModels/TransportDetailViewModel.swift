import Foundation



@MainActor
final class TransportDetailViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    @Published var errorType: ErrorViewType?
    @Published var carrierInfo: CarrierInfo?
    
    private let carrierService: CarrierServiceProtocol
    private let code: String
    
    init(carrierService: CarrierServiceProtocol, code: String) {
        self.carrierService = carrierService
        self.code = code
        Task {
            await loadCarrier()
        }
    }
    
    private func loadCarrier() async {
        isLoading = true
        defer{ isLoading = false }
        print("🔎 Загружаем перевозчика с кодом: \(code)")
        do {
            let info = try await carrierService.getCarrierInfo(code: code)
            carrierInfo = info
            errorType = nil
        } catch let error as ErrorViewType {
            errorType = error
        } catch {
            errorType = .serverError
        }
    }
}

