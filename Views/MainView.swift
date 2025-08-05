import SwiftUI
import OpenAPIURLSession

struct MainView: View {
    
    @State private var searchTextFrom: String = "Откуда"
    @State private var searchTextTo: String = "Куда"
    
    @Binding var selectedFromStation: Components.Schemas.Station?
    @Binding var selectedToStation: Components.Schemas.Station?
    
    @EnvironmentObject private var viewModel: StationsViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    private var isFindButtonEnabled: Bool {
        return selectedFromStation != nil && selectedToStation != nil
    }
    
    private var findButtonLabel: some View {
        Text("Найти")
            .fontWeight(.bold)
            .foregroundColor(.whiteUniversal)
            .padding(.horizontal, 45)
            .padding(.vertical, 20)
            .background(Color.blueUniversal)
            .cornerRadius(16)
    }
    
    private var fromStationField: some View {
        StationSelectionField(title: searchTextFrom, isSelected: selectedFromStation != nil) {
            navigationManager.path.append(Destination.citySearch(isSelectingFrom: true))
        }
    }
    
    private var toStationField: some View {
        StationSelectionField(title: searchTextTo, isSelected: selectedToStation != nil) {
            navigationManager.path.append(Destination.citySearch(isSelectingFrom: false))
        }
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    fromStationField
                    toStationField
                }
                .padding(.trailing, 16)
                .background(Color.whiteUniversal)
                .cornerRadius(20)
                .frame(height: 96)
                
                Button(action: {
                    guard selectedFromStation != nil && selectedToStation != nil else { return }
                    (searchTextFrom, searchTextTo) = (searchTextTo, searchTextFrom)
                    (selectedFromStation, selectedToStation) = (selectedToStation, selectedFromStation)
                }) {
                    Image("switch_ic")
                        .frame(width: 32, height: 32)
                }
                .padding(.leading)
            }
            .padding()
            .background(Color.blueUniversal)
            .cornerRadius(20)
            .padding(.top, 208)
            
            if isFindButtonEnabled, let from = selectedFromStation, let to = selectedToStation {
                Button(action: {
                    navigationManager.path.append(Destination.carrierList(from: from, to: to))
                }) {
                    findButtonLabel
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .onChange(of: selectedFromStation) { _, newValue in
            searchTextFrom = newValue?.title ?? "Откуда"
        }
        .onChange(of: selectedToStation) { _, newValue in
            searchTextTo = newValue?.title ?? "Куда"
        }
    }
}

struct StationSelectionField: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isSelected ? .black : .grayUniversal)
                .onTapGesture(perform: action)
                .lineLimit(1)
            Spacer()
        }
        .padding(.leading, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}




