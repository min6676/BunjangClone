//
//  LoginDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

import Alamofire
import KeychainSwift

class LogoutDataManager {

    func logout(_ parameters: LogoutInput, viewController: LogoutDialogViewController) {
        let keyChain = KeychainSwift()
        let jwt = keyChain.get("jwtToken")
        let headers: HTTPHeaders = ["x-access-token" : jwt!]

        AF.request("\(Constant.BASE_URL)/logout", method: .post, parameters: parameters, headers: headers).validate().responseDecodable(of: LogoutResponse.self) { response in
            switch response.result {
            case .success(let response):
                let message = response.message
                if response.isSuccess {
                    print(message)
                    keyChain.delete("jwtToken")
                    viewController.goToMain()
                } else {
                    switch response.code {
                    // JWT 미입력
                    case 2000:
                        print(message)
                        
                    // JWT 토큰 검증 실패
                    case 3000:
                        print(message)
                        
                    // 데이터베이스 에러
                    default:
                        print(message)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                viewController.presentAlert(title: "서버와의 연결이 원할하지 않습니다.")
            }
        }
    }
}
