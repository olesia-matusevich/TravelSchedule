import SwiftUI

struct CarrierListView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject var viewModel: CarrierListViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView().scaleEffect(1.5)
            } else {
                Text("\(viewModel.from.title ?? "Откуда") → \(viewModel.to.title ?? "Куда")")
                    .font(.system(size: 24))
                    .bold()
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                List(viewModel.filteredItems, id: \.self) { service in
                    Button {
                        navigationManager.path.append(Destination.carrierDetail(code: service.carrierCode))
                    } label: {
                        CarrierRow(serviceInfo: service)
                    }
                    .listRowInsets(.init(top: 0, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.path.removeLast()
                }) {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.backward")
                    }
                }
                .foregroundColor(.customBlack)
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            if !viewModel.isLoading {
                if viewModel.filteredItems.isEmpty && viewModel.errorMessage == nil {
                    Text("Вариантов нет")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.customBlack)
                } else if let err = viewModel.errorMessage {
                    Text(err)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            }
        }
        .overlay {
            Button {
                navigationManager.path.append(Destination.filter(carrierVM: viewModel))
            }
            label: {
                Text("Уточнить время")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,20)
                    .background(Color.blueUniversal.cornerRadius(16))
                    .foregroundColor(.whiteUniversal)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .task { await viewModel.load() }
    }
}


