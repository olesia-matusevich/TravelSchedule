import SwiftUI
import WebKit

struct UserAgreementView: View {
    @Binding var path: NavigationPath
    @State private var isLoading: Bool = false
    @State private var progress: Double = 0.0
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    var body: some View {
        ZStack {
            Color.customWhite
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if isLoading {
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(.linear)
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(.black)
                        .scaleEffect(x: 1, y: 0.75, anchor: .trailing)
                }
                WebView(
                    urlToDisplay: "https://yandex.ru/legal/practicum_offer/",
                    isLoading: $isLoading,
                    progress: $progress
                )
            }
            .navigationTitle("Пользовательское соглашение")
            .navigationBarTitleDisplayMode(.inline)
           
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        path.removeLast()
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "chevron.backward")
                        }
                    }
                    .foregroundColor(.customBlack)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}


#Preview {
    //    UserAgreementView()
}
