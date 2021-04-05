//
//  RegisteredItem.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

struct RegisterdItem: Encodable {
    let productImage: [String]
    let productName: String
    let categoryId: Int
    let subCategoryId: Int
    let thirdCategoryId: Int
    let price: Int
    var changePrice: Bool?
    var containDelivery: Bool?
    var setMyPlace: Bool?
    var content: String?
    var count: Int?
    var productCondition: Bool?
    var isExchange: Bool?
    let tag: [String]
}
