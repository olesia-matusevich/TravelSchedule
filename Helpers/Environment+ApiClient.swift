import SwiftUI

private struct ApiClientKey: EnvironmentKey {
    static var defaultValue: ApiClient? = nil
}

extension EnvironmentValues {
    var apiClient: ApiClient? {
        get { self[ApiClientKey.self] }
        set { self[ApiClientKey.self] = newValue }
    }
}


