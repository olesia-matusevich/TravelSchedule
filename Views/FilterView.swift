import SwiftUI

struct FilterView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var carrierListVM: CarrierListViewModel
    @StateObject var viewModel: FilterViewModel
    
    let timeOrder = [
        "Утро 06:00 - 12:00",
        "День 12:00 - 18:00",
        "Вечер 18:00 - 00:00",
        "Ночь 00:00 - 06:00"
    ]
    
    var body: some View {
        VStack {
            Text("Время отправления")
                .bold()
                .font(.system(size:24))
                .frame(maxWidth:.infinity, alignment:.leading)
                .padding(.leading)
            ForEach(timeOrder, id: \.self) { key in
                FilterTimeItem(timeString: key, isChecked: viewModel.binding(for: key))
            }
            Text("Показывать варианты с пересадками")
                .bold()
                .font(.system(size:24))
                .frame(maxWidth:.infinity, alignment:.leading)
                .padding(.leading)
            HStack {
                Text("Да")
                Spacer()
                RadioButton(isSelected: viewModel.showTransferRaces) {
                    viewModel.showTransferRaces = true
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            HStack {
                Text("Нет")
                Spacer()
                RadioButton(isSelected: !viewModel.showTransferRaces) {
                    viewModel.showTransferRaces = false
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            Spacer()
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
        .overlay{
            Button(action: {
                carrierListVM.filters.ranges = viewModel.ranges
                carrierListVM.filters.showTransferRaces = viewModel.showTransferRaces ? true : false
                
                navigationManager.path.removeLast()
            }) {
                Text("Применить")
                    .font(.system(size: 17))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blueUniversal.cornerRadius(16))
                    .padding(.horizontal)
                    .foregroundColor(.whiteUniversal)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 24)
        }
    }
}

struct FilterTimeItem: View {
    let timeString: String
    @Binding var isChecked: Bool
    
    var body: some View {
        HStack {
            Text(timeString)
            Spacer()
            Toggle("", isOn: $isChecked)
                .toggleStyle(CheckboxToggleStyle())
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}

