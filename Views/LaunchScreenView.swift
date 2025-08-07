import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        Image("launch_screen")
            .resizable()
            .ignoresSafeArea()
            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    LaunchScreenView()
}
