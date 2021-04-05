//
//  DialogViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/16.
//

import UIKit

class GoOutDialogViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goOutButtonPressed(_ sender: UIButton) {
        goToMain()
    }
}
