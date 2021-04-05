//
//  LogoutDialogViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/17.
//

import UIKit
import KakaoSDKAuth
import KeychainSwift

class LogoutDialogViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        self.showIndicator()
        if let oauthToken = KakaoSDKAuth.TokenManager().getToken() {
            LogoutDataManager().logout(LogoutInput(accessToken: oauthToken.accessToken), viewController: self)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
