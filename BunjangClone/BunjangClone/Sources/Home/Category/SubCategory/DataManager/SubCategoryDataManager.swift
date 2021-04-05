//
//  SubCategoryDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

import Alamofire
import KeychainSwift

class SubCategoryDataManager {

    func getSubCategory(id: Int, clicked: Int, viewController: BaseViewController) {
        let keyChain = KeychainSwift()
        if let jwt = keyChain.get("jwtToken") {
            let headers: HTTPHeaders = ["x-access-token" : jwt]
            AF.request("\(Constant.BASE_URL)/category/\(id)/?click=\(clicked)", method: .get, headers: headers).validate().responseDecodable(of: SubCategoryResponse.self) { response in
                switch response.result {
                case .success(let response):
                    let message = response.message
                    if response.isSuccess {
                        print(message)
                        viewController.setCategory(response.result)
                    } else {
                        switch response.code {
                        // 카테고리 메뉴 미존재
                        case 3007:
                            print(message)
                            
                        // 데이터베이스 에러
                        default:
                            print(message)
                        }
                    }
                case .failure(let error):
                    debugPrint(error)
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다.")
                    
                }
            }
        } else {
            viewController.presentBottomAlert(message: "로그인이 필요합니다.")
            viewController.goToLogin()
        }
        
    }
    
    func getSecondSubCategory(id: Int, subId: Int, clicked: Int, viewController: BaseViewController) {
        let keyChain = KeychainSwift()
        if let jwt = keyChain.get("jwtToken") {
            let headers: HTTPHeaders = ["x-access-token" : jwt]
            AF.request("\(Constant.BASE_URL)/category/\(id)/subCategory/\(subId)?click=\(clicked)", method: .get, headers: headers).validate().responseDecodable(of: SubCategoryResponse.self) { response in
                switch response.result {
                case .success(let response):
                    let message = response.message
                    if response.isSuccess {
                        print(message)
                        viewController.setCategory(response.result)
                    } else {
                        switch response.code {
                        // 카테고리 메뉴 미존재
                        case 3007:
                            print(message)
                            
                        // 데이터베이스 에러
                        default:
                            print(message)
                        }
                    }
                case .failure(let error):
                    debugPrint(error)
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다.")
                    
                }
            }
        } else {
            viewController.presentBottomAlert(message: "로그인이 필요합니다.")
            viewController.goToLogin()
        }
        
    }
}
