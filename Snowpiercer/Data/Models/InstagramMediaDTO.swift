//
//  InstagramMediaDTO.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 17/05/25.
//

import Foundation

// MARK: - DTOs

struct InstagramMediaDTO: Codable {
    let id: String?
    let code: String?
    let mediaType: Int?
    let takenAt: Int?
    let likeCount: Int?
    let commentCount: Int?
    let playCount: Int?
    let videoDuration: Double?
    let hasLiked: Bool?
    let caption: CaptionDTO?
    let user: UserDTO?
    let imageVersions2: ImageVersions2DTO?
    let videoVersions: [VideoVersionDTO]?
    let carouselMedia: [CarouselMediaDTO]?
}

struct CaptionDTO: Codable {
    let text: String?
    let createdAt: Int?
    let user: UserDTO?
}

struct UserDTO: Codable {
    let id: Int?
    let username: String?
    let fullName: String?
    let profilePicUrl: String?
    let isVerified: Bool?
}

struct ImageVersions2DTO: Codable {
    let candidates: [ImageCandidateDTO]?
    let additionalCandidates: [String: [ImageCandidateDTO]]?
}

struct ImageCandidateDTO: Codable {
    let url: String?
    let width: Int?
    let height: Int?
}

struct VideoVersionDTO: Codable {
    let url: String?
    let width: Int?
    let height: Int?
    let id: String?
    let bandwidth: Int?
    let type: Int?
}

struct CarouselMediaDTO: Codable {
    let id: String?
    let mediaType: Int?
    let imageVersions2: ImageVersions2DTO?
    let videoVersions: [VideoVersionDTO]?
}
