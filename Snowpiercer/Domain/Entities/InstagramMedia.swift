////
////  InstagramMedia.swift
////  Snowpiercer
////
////  Created by Gerson Vieira on 17/05/25.
////
//
//import Foundation
//import CoreGraphics
//
//// MARK: - Models
//
//struct InstagramMedia: Identifiable {
//    let id: String
//    let code: String
//    let mediaType: Int
//    let takenAt: Date
//    let likeCount: Int
//    let commentCount: Int
//    let playCount: Int?
//    let videoDuration: Double?
//    let hasLiked: Bool
//    let caption: String?
//    let user: UserModel
//    let images: [ImageModel]
//    let videos: [VideoModel]
//    let carousel: [InstagramMediaDTO]?
//}
//
//struct UserModel {
//    let id: Int
//    let username: String
//    let fullName: String
//    let profilePicture: String
//    let isVerified: Bool
//}
//
//struct ImageModel {
//    let url: String
//    let width: Int
//    let height: Int
//}
//
//struct VideoModel {
//    let url: String
//    let width: Int
//    let height: Int
//    let id: String
//    let bandwidth: Int
//    let type: Int
//}
//
//// MARK: - Mapping Extension
//
//extension MediaModel {
//    static func from(dto: MediaDTO) -> MediaModel? {
//        guard let id = dto.id,
//              let code = dto.code,
//              let mediaType = dto.mediaType,
//              let takenAt = dto.takenAt,
//              let likeCount = dto.likeCount,
//              let commentCount = dto.commentCount,
//              let hasLiked = dto.hasLiked,
//              let userDTO = dto.user,
//              let user = UserModel.from(dto: userDTO) else {
//            return nil
//        }
//
//        let images = dto.imageVersions2?.candidates?.compactMap { ImageModel.from(dto: $0) } ?? []
//        let videos = dto.videoVersions?.compactMap { VideoModel.from(dto: $0) } ?? []
//        let caption = dto.caption?.text
//        let carousel = dto.carouselMedia?.compactMap { MediaModel.from(dto: $0) }
//
//        return MediaModel(
//            id: id,
//            code: code,
//            mediaType: mediaType,
//            takenAt: Date(timeIntervalSince1970: TimeInterval(takenAt)),
//            likeCount: likeCount,
//            commentCount: commentCount,
//            playCount: dto.playCount,
//            videoDuration: dto.videoDuration,
//            hasLiked: hasLiked,
//            caption: caption,
//            user: user,
//            images: images,
//            videos: videos,
//            carousel: carousel
//        )
//    }
//}
//
//extension UserModel {
//    static func from(dto: UserDTO) -> UserModel? {
//        guard let id = dto.id,
//              let username = dto.username,
//              let fullName = dto.fullName,
//              let profilePicUrl = dto.profilePicUrl,
//              let isVerified = dto.isVerified else {
//            return nil
//        }
//
//        return UserModel(
//            id: id,
//            username: username,
//            fullName: fullName,
//            profilePicture: profilePicUrl,
//            isVerified: isVerified
//        )
//    }
//}
//
//extension ImageModel {
//    static func from(dto: ImageCandidateDTO) -> ImageModel? {
//        guard let url = dto.url, let width = dto.width, let height = dto.height else { return nil }
//        return ImageModel(url: url, width: width, height: height)
//    }
//}
//
//extension VideoModel {
//    static func from(dto: VideoVersionDTO) -> VideoModel? {
//        guard let url = dto.url,
//              let width = dto.width,
//              let height = dto.height,
//              let id = dto.id,
//              let bandwidth = dto.bandwidth,
//              let type = dto.type else { return nil }
//
//        return VideoModel(url: url, width: width, height: height, id: id, bandwidth: bandwidth, type: type)
//    }
//}
//
//extension MediaModel {
//    static func from(dto: CarouselMediaDTO) -> MediaModel? {
//        MediaModel.from(dto: MediaDTO(
//            id: dto.id,
//            code: nil,
//            mediaType: dto.mediaType,
//            takenAt: nil,
//            likeCount: 0,
//            commentCount: 0,
//            playCount: nil,
//            videoDuration: nil,
//            hasLiked: false,
//            caption: nil,
//            user: nil,
//            imageVersions2: dto.imageVersions2,
//            videoVersions: dto.videoVersions,
//            carouselMedia: nil
//        ))
//    }
//}
