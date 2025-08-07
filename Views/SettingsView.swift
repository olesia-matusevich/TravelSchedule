import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var themeManager: ThemeManager
    
//    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isDarkMode: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
           
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    Text("Тёмная тема")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.customBlack)
                    Spacer()
                    Toggle("", isOn: $themeManager.isDarkMode)
                        .labelsHidden()
                        .tint(.blueUniversal)
                        
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 30)
               

                Button(action: {
                    navigationPath.append(SettingsDestination.networkError)
                }) {
                    Text("Show view Network Error")
                        .font(.system(size: 17, weight: .regular))
                        .padding(.horizontal, 16)
                        .foregroundColor(.blue)

                }
                Button(action: {
                    navigationPath.append(SettingsDestination.serverError)
                }) {
                    Text("Show view Serwer Error")
                        .font(.system(size: 17, weight: .regular))
                        .padding(.horizontal, 16)
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
