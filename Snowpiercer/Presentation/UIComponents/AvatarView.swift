import SwiftUI
import Nuke

struct AvatarView: View {
    
    enum switchSize: CGFloat {
        case max = 60
        case min = 30
    }
    
    let size: switchSize
    let user: InstagramUser
    
    @StateObject var viewModel: AvatarViewModel
    @State private var image: UIImage?
    
    init(size: switchSize, user: InstagramUser) {
           self.size = size
           self.user = user
           _viewModel = StateObject(wrappedValue: AvatarViewModel(url: user.avatar,
                                                                  size: CGSize(width: size.rawValue * 2, height: size.rawValue * 2)))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image  {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .transition(.scale)
            } else {
                Text(fallbackInitial())
                    .font(.system(size: size.rawValue / 2, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: size.rawValue, height: size.rawValue)
                    .background(Color.gray)
            }
        }
        .frame(width: size.rawValue, height: size.rawValue)
        .clipShape(Circle())
        .task {
            await viewModel.load()
        }
    }
    
    private func fallbackInitial() -> String {
        guard let name = user.fullName else { return String() }
        return name.first.map { String($0).uppercased() } ?? String()
    }
}

