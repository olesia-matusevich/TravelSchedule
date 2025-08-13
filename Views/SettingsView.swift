import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var navigationPath = NavigationPath()
    
    private var imageSize: Double = 24
    private var stackHeight: Double = 120
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                VStack {
                    HStack {
                        Text("Тёмная тема")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.customBlack)
                        Spacer()
                        Toggle("", isOn: $themeManager.isDarkMode)
                            .labelsHidden()
                            .tint(.blueUniversal)
                    }
                    .frame(height: stackHeight/2)
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Text("Пользовательское соглашение")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color.customBlack)
                        
                        Spacer()
                        
                        Image("arrow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageSize)
                    }
                    .frame(height: stackHeight/2)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        navigationPath.append(SettingsDestination.userAgreement)
                    }
                }
                .padding(.top, 16)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.customBlack)
                    Text("Версия 1.0 (beta)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.customBlack)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
                
            }
            .navigationDestination(for: SettingsDestination.self) { destination in
                Group {
                    switch destination {
                    case .userAgreement:
                        UserAgreementView(path: $navigationPath)
                    }
                }
            }
        }
    }
    
    enum SettingsDestination: Hashable {
        case userAgreement
    }
}


