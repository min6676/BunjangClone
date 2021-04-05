//
//  Constant.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/16.
//

import Alamofire

struct Constant {
    static let loginViewControllerIdentifier = "LoginViewController"
    static let mainTabBarControllerIdentifier = "MainTabBarController"
    static let registerViewControllerIdentifier = "RegisterViewController"
    static let subCategoryViewController = "SubCategoryViewController"
    static let secondSubCategoryViewController = "SecondSubCategoryViewController"
    static let registerCategoryViewControllerIdentifier = "RegisterCategoryViewController"

    static let homeStoryBoardName = "HomeStoryBoard"
    static let registerStoryBoardName = "RegisterStoryboard"
    
    static let BASE_URL = "https://dev.evertime.shop"
    
    // home
    static let homeHeaderViewIdentifier = "HeaderView"
    static let homeCollectionViewCell = "HomeCollectionViewCell"
    static let goToFirstCategorySegueIdentifier = "GoToFirstCategory"
    static let detailViewControllerIdentifier = "DetailViewController"
    
    // detail
    static let reviewCellIdentifier = "ReviewCell"
    
    // category
    static let firstCategoryCellIdentifier = "CategoryCell"
    static let firstCategorySectionIdentifier = "CategorySection"
    static let subCategoryCellIdentifier = "SubCategoryCell"
    static let subCategoryFooterView = "SubCategoryFooterView"
    static let productCell = "ProductCell"
    static let productHeaderView = "ProductHeaderView"
    
    
    // follow
    static let recommendCell = "RecommendCell"
    static let followingCell = "FollowingCell"
    static let feedHeaderView = "FeedHeaderView"
    
    // register
    
    static let registerSubCategoryViewController = "RegisterSubCategoryViewController"
    static let registerThirdCategoryViewController = "RegisterThirdCategoryViewController"
}
