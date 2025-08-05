//
//  LaunchScreemView.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 28/07/2025.
//

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
