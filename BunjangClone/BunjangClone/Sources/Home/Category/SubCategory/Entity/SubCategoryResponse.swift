//
//  SubCategoryResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/21.
//

struct SubCategoryResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Category]
}

//struct SubCategory: Decodable {
//    let id: Int
//    let name: String
//    let count: Int
//}
