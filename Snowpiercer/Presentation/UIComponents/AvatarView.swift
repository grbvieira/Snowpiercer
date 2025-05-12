import SwiftUI
import Nuke

struct AvatarView: View {
    
    enum switchSize: CGFloat {
        case max = 60
        case min = 30
    }
    
    let size: switchSize
    let user: InstagramUser
    
    @State private var image: UIImage?
    @State private var isLoaded = false
    
    private static var cache = NSCache<NSURL, UIImage>()
    
    var body: some View {
        ZStack {
            if let image = image {
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
        .onAppear {
            loadImage()
        }
    }
    
    private func fallbackInitial() -> String {
        guard let name = user.fullName else { return String() }
        return name.first.map { String($0).uppercased() } ?? String()
    }
    
    private func loadImage() {
        guard let url = user.avatar else { return }
        
        if let cached = AvatarView.cache.object(forKey: url as NSURL) {
            self.image = cached
            return
        }
        
        let request = ImageRequest(
            url: url,
            processors: [ImageProcessors.Resize(size: CGSize(width: size.rawValue * 2, height: size.rawValue * 2))]
        )
        
        Task {
            do {
                let img = try await ImagePipeline.shared.image(for: request)
                AvatarView.cache.setObject(img, forKey: url as NSURL)
                await MainActor.run {
                    withAnimation(.easeIn(duration: 0.25)) {
                        self.image = img
                        self.isLoaded = true
                    }
                }
            } catch {
                
            }
        }
    }
}

