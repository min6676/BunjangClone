//
//  HomeItemResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/22.
//

import Foundation

struct HomeItemResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeItem]?
}

struct HomeItem: Decodable {
    let postId: Int
    let productName: String
    let price: Int
    let postImgURL: String?
    let userId: Int
    let userName: String
    let profileImg: String?
    let time: String
}
