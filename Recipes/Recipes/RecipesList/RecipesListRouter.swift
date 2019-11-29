//
//  RecipesListRouter.swift
//  Recipes
//
//  Created by Hugo Alonso Luis on 25/11/2019.
//

import Foundation
import VIPER
import UIKit

final class RecipesListRouter: RouterInterface {

    weak var presenter: RecipesListPresenterRouterInterface!

    weak var viewController: UIViewController?
}

extension RecipesListRouter: RecipesListRouterPresenterInterface {
    func pushToDetailScreen(using url: URL, title: String) {
        let details = DetailWebPage()
        viewController?.navigationController?.pushViewController(details, animated: true)
        details.loadDetailsWebpage(url: url, title: title)

    }

    func pushToDetailScreen(data: Data, baseURL: URL, title: String) {
        let details = DetailWebPage()
        viewController?.navigationController?.pushViewController(details, animated: true)
        details.loadDetailsWebpageFrom(data: data, baseURL: baseURL, title: title)
    }
}
