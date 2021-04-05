//
//  CategoryResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/19.
//

struct CategoryResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Category]
}

struct Category: Decodable {
    let id: Int
    let name: String
    var count: Int? 
}
