import SwiftUI

struct TransportDetailView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject var viewModel: TransportDetailViewModel
    
    private let stackHeight: Double = 60
    private let logoHeight: Double = 104
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                ProgressView("Загрузка...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorType {
                let path = navigationManager.path
                ErrorView(navigationPath: $navigationManager.path, errorType: error)
                
            } else {
                contentView
            }
        }
        .padding()
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationManager.path.removeLast()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .foregroundColor(.customBlack)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var contentView: some View {
        VStack(spacing: 16) {
            logoView
            titleView
            contactStack
            Spacer()
        }
        .padding(16)
    }
    
    private var backgroundView: some View {
        Color.customWhite
            .ignoresSafeArea()
    }
    
    private var logoView: some View {
        AsyncImage(url: viewModel.carrierInfo?.imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: logoHeight)
                    .frame(height: logoHeight)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(maxWidth: .infinity, alignment: .center) 
            @unknown default:
                Image("mock_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: logoHeight)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var titleView: some View {
        Text(viewModel.carrierInfo?.title ?? "")
            .font(.system(size: 24, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.customBlack)
    }
    
    private var contactStack: some View {
        VStack {
            contactItem(title: "E-mail", value: (viewModel.carrierInfo?.email ?? "").isEmpty ? "нет информации" : viewModel.carrierInfo?.email ?? "")
            contactItem(title: "Телефон", value: (viewModel.carrierInfo?.phoneNumber ?? "").isEmpty ? "нет информации" : viewModel.carrierInfo?.phoneNumber ?? "")
        }
    }
    
    private func contactItem(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.customBlack)
            
            Text(value)
                .font(.system(size: 12, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blueUniversal)
        }
        .frame(height: stackHeight)
    }
}

