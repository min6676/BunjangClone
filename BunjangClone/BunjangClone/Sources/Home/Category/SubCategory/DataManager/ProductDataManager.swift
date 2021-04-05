//
//  LoginDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

import Alamofire
import KeychainSwift

class ProductDataManager {
    func getSubCategory(id: Int, page: Int, viewController: SubCategoryViewController) {
        let keyChain = KeychainSwift()
        if let jwt = keyChain.get("jwtToken") {
            let headers: HTTPHeaders = ["x-access-token" : jwt]
            AF.request("\(Constant.BASE_URL)/category/\(id)/product/?page=\(page)", method: .get, headers: headers).validate().responseDecodable(of: ProductResponse.self) { response in
                switch response.result {
                case .success(let response):
                    let message = response.message
                    if response.isSuccess {
                        print(message)
                        viewController.setProduct(response.result!)
                    } else {
                        switch response.code {
                        case 3008:
                            viewController.presentAlert(title: message)
                            print(message)
                        default:
                            print(message)
                        }

                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다.")
                }
            }
        } else {
            viewController.presentBottomAlert(message: "로그인이 필요합니다.")
            viewController.goToLogin()
        }
        
    }
    
    func getSecondSubCategory(id: Int, subId: Int, page: Int, viewController: SecondSubCategoryViewController) {
        let keyChain = KeychainSwift()
        if let jwt = keyChain.get("jwtToken") {
            let headers: HTTPHeaders = ["x-access-token" : jwt]
            AF.request("\(Constant.BASE_URL)/category/\(id)/subCategory/\(subId)/product/?page=\(page)", method: .get, headers: headers).validate().responseDecodable(of: ProductResponse.self) { response in
                switch response.result {
                case .success(let response):
                    let message = response.message
                    if response.isSuccess {
                        print(message)
                        viewController.setProduct(response.result!)
                    } else {
                        switch response.code {
                        case 3008:
                            viewController.presentAlert(title: message)
                            print(message)
                        default:
                            print(message)
                        }

                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다.")
                }
            }
        } else {
            viewController.presentBottomAlert(message: "로그인이 필요합니다.")
            viewController.goToLogin()
        }
        
    }
}
