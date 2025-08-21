import Foundation

@MainActor
final class CarrierListViewModel: ObservableObject {
    
    @Published var items: [ServiceInformation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var errorType: ErrorViewType?

    private let apiClient: ApiClient
    let from: Components.Schemas.Station
    let to: Components.Schemas.Station

    init(apiClient: ApiClient, from: Components.Schemas.Station, to: Components.Schemas.Station) {
        self.apiClient = apiClient
        self.from = from
        self.to = to
    }

    func load() async {
        isLoading = true; defer { isLoading = false }
        do {
            let fromCode = from.codes?.yandex_code ?? ""
            let toCode = to.codes?.yandex_code ?? ""
            items = try await apiClient.search(from: fromCode, to: toCode)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            items = []
        }
    }
}


