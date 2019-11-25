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

}
