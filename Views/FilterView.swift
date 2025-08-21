import SwiftUI

struct FilterView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject var viewModel: FilterViewModel
    
    var body: some View {
        VStack {
            Text("Время отправления")
                .bold()
                .font(.system(size:24))
                .frame(maxWidth:.infinity, alignment:.leading)
                .padding(.leading)
            ForEach(Array(viewModel.ranges.keys), id: \.self) { key in
                HStack {
                    FilterTimeItem(timeString: key)
                }
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
    @State private var isChecked: Bool = false
    var body: some View {
        HStack {
            Text(timeString)
            Spacer()
            Toggle("Включить опцию", isOn: $isChecked)
                .toggleStyle(CheckboxToggleStyle())
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}
