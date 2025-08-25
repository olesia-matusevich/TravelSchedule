import Foundation

@MainActor
final class CitySearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [Components.Schemas.Settlement] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: ApiClient

    init(apiClient: ApiClient) { self.apiClient = apiClient }

    func load() async {
        isLoading = true; defer { isLoading = false }
        do {
            let fetched = try await apiClient.getFilteredCities()
            results = filtered(fetched, by: searchText)
        } catch {
            errorMessage = error.localizedDescription
            results = []
        }
    }

    func updateQuery(_ q: String) {
        searchText = q
        results = filtered(results, by: q)
    }

    private func filtered(_ arr: [Components.Schemas.Settlement], by q: String) -> [Components.Schemas.Settlement] {
        let base = q.isEmpty ? arr : arr.filter {
            $0.title?.localizedCaseInsensitiveContains(q) ?? false
        }
        return base.filter {
            ($0.title ?? "").isEmpty == false
        }.sorted {
            ($0.title ?? "") < ($1.title ?? "")
        }
    }
}

