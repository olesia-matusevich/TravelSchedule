import SwiftUI

struct SettingsView: View {

    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
           
            VStack(alignment: .leading, spacing: 16) {
                Button(action: {
                    navigationPath.append(SettingsDestination.networkError)
                }) {
                    Text("Show view Network Error")
                        .font(.system(size: 17, weight: .regular))
                        .padding(.top, 150)
                        .foregroundColor(.blue)
                }
                Button(action: {
                    navigationPath.append(SettingsDestination.serverError)
                }) {
                    Text("Show view Serwer Error")
                        .font(.system(size: 17, weight: .regular))
                        .padding(.top, 30)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: SettingsDestination.self) { destination in
                Group {
                    switch destination {
                    case .networkError:
                        ErrorView(errorType: .networkError)
                    case .serverError:
                        ErrorView(errorType: .serverError)
                    }
                }
            }
        }
    }
    
enum SettingsDestination: Hashable {
     case networkError
     case serverError
 }
}
#Preview {
    SettingsView()
}
