//
//  RegisterSubCategoryViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

import UIKit

class RegisterSubCategoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var categoryArray : [Category] = []
    var currentCategory : Category = Category(id: 0, name: "default")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentCategory.name
        
        showIndicator()
        SubCategoryDataManager().getSubCategory(id: currentCategory.id, clicked: 1, viewController: self)

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

extension RegisterSubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
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
        if let vc = storyboard.instantiateViewController(withIdentifier: Constant.registerThirdCategoryViewController) as? RegisterThirdCategoryViewController {
            vc.currentCategory = categoryArray[indexPath.row]
            vc.parentCategory = currentCategory
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
