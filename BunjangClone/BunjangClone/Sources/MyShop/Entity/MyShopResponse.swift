//
//  MyShopResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/25.
//

import Foundation

struct MyShopResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let Message: String
    var result: MyResult?
}

struct MyResult: Decodable {
    let UserData: UserData
    let ReviewData: ReviewData
    let JjimData: JjimData
    let Follower: Int
    let Following: Int
    var MySellInfo: MySellInfo?
}

struct UserData: Decodable {
    let userId: Int
    let userName: String
    var profileImg: String?
    var product: Int?
    var follower: Int?
}

struct ReviewData: Decodable {
    let reviewCount: Int
    let StarPoint: Int
}

struct JjimData: Decodable {
    let count: Int
}

struct MySellInfo: Decodable {
    let postId: Int
    let userId: Int
    let productName: String
    let price: Int
    let postImgURL: String
    let uploadDate: String
    let sellStatus: Int
}
