//
//  RegisterThirdCategoryViewController.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/23.
//

import UIKit

class RegisterThirdCategoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var categoryArray : [Category] = []
    var currentCategory = Category(id: 0, name: "default")
    var parentCategory = Category(id: 0, name: "default")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentCategory.name
        
        showIndicator()
        SubCategoryDataManager().getSecondSubCategory(id: parentCategory.id, subId: currentCategory.id, clicked: 1, viewController: self)
        
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

extension RegisterThirdCategoryViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let vcs = navigationController?.viewControllers, vcs.count > 1 else { return }
        let categoryId = [parentCategory, currentCategory, categoryArray[indexPath.row]]
        let vc = vcs[vcs.count - 4] as? RegisterViewController
        vc?.categoryId = categoryId
        navigationController?.popToViewController(vc!, animated: true)
    }
}
