//
//  AutoLoginResponse.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/20.
//

struct AutoLoginResponse: Decodable {
    let isSuccess : Bool
    let code : Int
    let message : String
}
