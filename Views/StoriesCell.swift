import SwiftUI

private extension CGFloat {
    static let storiesRowHeight: CGFloat = 140
    static let storiesRowWidth: CGFloat = 92
    static let storiesLineWidth: CGFloat = 4
    static let storiesImageRadius: CGFloat = 16
}

struct StoriesCell: View {
    var stories: Stories
    
    @EnvironmentObject var viewModel: StoriesViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                previewImage
            }
            VStack {
                text
            }
            .padding(.init(top: 83, leading: 0, bottom: 12, trailing: 8))
            .padding(.horizontal, 4)
        }
        .onTapGesture {
            if let index = viewModel.story.firstIndex(where: { $0.id == stories.id }) {
                viewModel.selectStory(at: index)
            }
        }
    }
    
    private var previewImage: some View {
        Image(stories.previewImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: .storiesRowWidth, height: .storiesRowHeight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .opacity(viewModel.isStoryViewed(stories) ? 0.5 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: .storiesImageRadius - .storiesLineWidth/2)
                    .stroke(viewModel.isStoryViewed(stories) ? Color.clear : Color.blueUniversal, lineWidth: .storiesLineWidth)
                    .frame(width: .storiesRowWidth - .storiesLineWidth, height: .storiesRowHeight - .storiesLineWidth)
            )
    }
    
    private var text: some View {
        Text("Text Text Text Text Text Text Text")
            .font(.system(size: 12, weight: .regular))
            .frame(width: 76, height: 45)
            .foregroundStyle(.white)
            .lineLimit(3)
    }
}

#Preview {
    StoriesCell(stories: Stories(previewImage: "ConductorGirlPreview", images: ["ConductorGirlBig", "ConductorGirlTwoBig"]))
        .environmentObject(StoriesViewModel())
}
