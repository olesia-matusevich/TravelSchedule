import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            Text("loading...")
                .padding(20)
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.5)
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            // Используйте .task для выполнения асинхронных действий
            await Task.sleep(1_000_000_000) // Имитация задержки
            navigationManager.resetToRoot()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoadingView()
        .environmentObject(NavigationManager())
}
