import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .grayUniversal : .customBlack)
                .padding(.leading, 8)
            
            TextField("Введите запрос", text: $searchText)
                .padding(8)
                .padding(.trailing, 8)
                .foregroundColor(.customBlack)
                .focused($isTextFieldFocused)
                .overlay(
                    HStack {
                        Spacer()
                        if isTextFieldFocused {
                            Button(action: {
                                searchText = ""
                                isTextFieldFocused = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.grayUniversal)
                            }
                            .padding(.trailing, 7)
                        }
                    }
                )
        }
        .background(.backgroundSearchBar)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

#Preview {
    struct SearchBarPreview: View {
        @State private var searchText = ""
        var body: some View {
            SearchBar(searchText: $searchText)
        }
    }
    return SearchBarPreview()
}
