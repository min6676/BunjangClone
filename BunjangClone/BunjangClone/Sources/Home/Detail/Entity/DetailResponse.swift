//
//  DetailResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

import Foundation

struct DetailResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: DetailResult
}

struct DetailResult: Decodable {
    var detailInfo: [DetailInfo]?
    var OtherProducts: [OtherProducts]
    var StoreReview: [StoreReview]
}

struct DetailInfo: Decodable {
    let postId: Int
    let postImages: String
    let productName: String
    let price: Int
    let time: String
    let watched: Int?
    let jjim: Int
    let productCondition: Int
    let containDelivery: Int
    let isExchange: Int
    let count: Int
    let content: String?
    let place: String?
    let category: String?
    let postQuestion: Int
    let tags: String?
    let userId: Int
    let userName: String
    var profileImg: String?
    var userOpenDate: String?
    var follower: Int?
    var totalPost: Int?
    var totalReview: Int?
    var averageStar: Int?
}

struct OtherProducts: Decodable {
    let postId: Int
    let postImg: String?
    let price: Int
}

struct StoreReview: Decodable {
    let reviewId: Int
    let reviewer: String
    var reviewerProfile: String?
    let content: String
    let star: Double
    let createAt: String
}
