
import SwiftUI
import OpenAPIURLSession

struct MainView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var stationsVM: StationsViewModel
    @StateObject private var viewModel: MainViewModel
    @State private var presentStory = false
    
    init(stationsVM: StationsViewModel) {
        _viewModel = StateObject(wrappedValue: MainViewModel(stationsVM: stationsVM))
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.storiesVM.story) { story in
                        StoriesCell(stories: story)
                            .environmentObject(viewModel.storiesVM)
                    }
                }
            }
            .frame(height: 140)
            .scrollIndicators(.hidden)
            StationSelectionSection(viewModel: viewModel)
            
            if let from = stationsVM.selectedFromStation,
               let to = stationsVM.selectedToStation {
                Button {
                    navigationManager.path.append(Destination.carrierList(from: from, to: to))
                } label: {
                    Text("Найти")
                        .fontWeight(.bold)
                        .foregroundColor(.whiteUniversal)
                        .padding(.horizontal, 45)
                        .padding(.vertical, 20)
                        .background(Color.blueUniversal)
                        .cornerRadius(16)
                }
            }
            Spacer()
        }
        .padding(.horizontal).padding(.top, 24)
        .fullScreenCover(isPresented: $presentStory) {
            StoryView(viewModel: viewModel.storiesVM)
        }
        .onReceive(viewModel.storiesVM.$showStoryView) { shouldShow in
            presentStory = shouldShow
        }
        .onChange(of: presentStory) { _, new in
            if !new {
                viewModel.storiesVM.showStoryView = false
            }
        }
        .task {
            await stationsVM.loadCitiesIfNeeded()
        }
    }
}


private struct StationSelectionSection: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var stationsVM: StationsViewModel
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                StationSelectionField(
                    title: viewModel.stationsVM.selectedFromStation?.title ?? "Откуда",
                    isSelected: viewModel.stationsVM.selectedFromStation != nil
                ) {
                    navigationManager.path.append(Destination.citySearch(isSelectingFrom: true))
                }
                
                StationSelectionField(
                    title: viewModel.stationsVM.selectedToStation?.title ?? "Куда",
                    isSelected: viewModel.stationsVM.selectedToStation != nil
                ) {
                    navigationManager.path.append(Destination.citySearch(isSelectingFrom: false))
                }
            }
            .padding(.trailing, 16)
            .background(Color.whiteUniversal)
            .cornerRadius(20)
            .frame(height: 96)
            
            Button { stationsVM.swapStations() } label: {
                Image("switch_ic").frame(width: 32, height: 32)
            }
            .padding(.leading)
        }
        .padding()
        .background(Color.blueUniversal)
        .cornerRadius(20)
        .padding(.top, 44)
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

