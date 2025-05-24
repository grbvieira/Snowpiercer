////
////  LoadPostService.swift
////  Snowpiercer
////
////  Created by Gerson Vieira on 17/05/25.
////
//
//import Swiftagram
//import SwiftagramCrypto
//import Combine
//
//class LoadPostService {
//    private var bin = Set<AnyCancellable>()
//    
//    static let shared = LoadPostService()
//    
//    func getPost(secret: Secret, id: String) async throws -> [InstagramMedia] {
//        return try await withCheckedThrowingContinuation { continuation in
//            Endpoint.user(id)
//                .posts
//                .unlock(with: secret)
//                .session(.instagram)
//                .pages(1, delay: .seconds(2))
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished: break
//                    case .failure(let error):
//                        continuation.resume(throwing: error)
//                    }
//                }, receiveValue: { posts in
//              //      let userPosts = posts.media?.compactMap( InstagramMediaDTO(from: $0).)
//                })
//                .store(in: &self.bin)
//        }
//    }
//}
