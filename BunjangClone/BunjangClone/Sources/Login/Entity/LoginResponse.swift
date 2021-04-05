//
//  LoginResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

struct LoginResponse: Decodable {
    
    let isSuccess: Bool
    let code: Int
    let message: String
    
    let result: LoginResult
}

struct LoginResult: Decodable {
    let id: Int
    let jwt: String
}
