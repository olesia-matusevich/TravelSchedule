import SwiftUI

enum ErrorViewType: String, Sendable, Error {
    case serverError
    case networkError
    
    var image: Image {
        Image(self.rawValue)
    }
    var title: String {
        switch self {
        case .networkError: return "Нет интернета"
        case .serverError: return "Ошибка сервера"
        }
    }
}

struct ErrorView: View {
    @Binding var navigationPath: NavigationPath
    
    let errorType: ErrorViewType
    private let imageSize: Double = 223
    
    var body: some View {
        ZStack {
            Color.customWhite
                .ignoresSafeArea()
            VStack(spacing: 16) {
                errorType.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: 70))
                Text(errorType.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.customBlack)
            }
            .padding()
        }
    }
}

