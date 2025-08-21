import SwiftUI

struct RadioButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.customWhite)
                .overlay(
                    Circle()
                        .stroke(Color.customBlack, lineWidth: 2)
                )
            if isSelected {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.customBlack)
            }
        }
        .onTapGesture {
            action()
        }
    }
}
