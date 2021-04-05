//
//  RegisterResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

import Foundation

struct RegisterResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    var result: RegisterResult?
}

struct RegisterResult: Decodable {
    let postId: Int
}

