//
//  RegisterCategoryViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

import UIKit

class RegisterCategoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var categoryArray : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "카테고리"
         
        showIndicator()
        CategoryDataManager().getCategory(viewController: self)

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func setCategory(_ result: [Category]) {
        dismissIndicator()
        
        categoryArray = result
        self.tableView.reloadData()
    }
}

extension RegisterCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.tintColor = .lightGray
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: Constant.registerStoryBoardName, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: Constant.registerSubCategoryViewController) as? RegisterSubCategoryViewController {
            vc.currentCategory = categoryArray[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}
