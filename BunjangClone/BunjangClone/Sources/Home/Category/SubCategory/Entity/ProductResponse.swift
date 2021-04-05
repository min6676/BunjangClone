//
//  ProductResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/21.
//

import Foundation

struct ProductResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Product]?
}

struct Product: Decodable {
    let postId: Int
    let productName: String
    let price: Int
    let postImgURL: String
}
