//
//  RecommendResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/26.
//

import Foundation

struct RecommendResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [FollowingData]
}

struct FollowingData: Decodable {
    let userData: [UserData]
    let postData: [PostData]
    var isFollowing: Bool?
}
    
struct PostData: Decodable {
    let userId: Int
    let postId: Int
    let postImgURL: String
    let price: Int
}
