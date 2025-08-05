import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.5)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            navigationManager.resetToRoot()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoadingView()
        .environmentObject(NavigationManager())
}
