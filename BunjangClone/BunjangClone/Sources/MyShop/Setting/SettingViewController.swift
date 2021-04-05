//
//  SettingTableViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/16.
//

import UIKit
import KakaoSDKUser

class SettingViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let userSettingArray = ["계정 설정", "알림 설정", "우리동네 지역 설정", "배송지 설정", "계좌 설정", "차단 상점 관리"]
    let serviceInfoArray = ["이용약관", "개인정보 처리방침", "위치기반 서비스 이용약관", "오픈소스 라이선스", "버전정보 (7.4.2)"]
    let sections = ["사용자 설정", "서비스 정보", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.title = "설정"
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = #colorLiteral(red: 0.9607003331, green: 0.9608381391, blue: 0.9606701732, alpha: 1)
            view.textLabel?.textColor = UIColor.black
            view.textLabel?.font = .NotoSans(.medium, size: 13)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userSettingArray.count
        } else if section == 1 {
            return serviceInfoArray.count
        } else if section == 2 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .NotoSans(.regular, size: 13)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = userSettingArray[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = serviceInfoArray[indexPath.row]
        } else {
            cell.textLabel?.text = "로그아웃"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            performSegue(withIdentifier: "goToDialog", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
