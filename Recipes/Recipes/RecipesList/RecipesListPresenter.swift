//
//  RecipesListPresenter.swift
//  Recipes
//
//  Created by Hugo Alonso Luis on 25/11/2019.
//

import Foundation
import VIPER

final class RecipesListPresenter: PresenterInterface {

    var router: RecipesListRouterPresenterInterface!
    var interactor: RecipesListInteractorPresenterInterface!
    weak var view: RecipesListViewPresenterInterface!

}

extension RecipesListPresenter: RecipesListPresenterRouterInterface {

}

extension RecipesListPresenter: RecipesListPresenterInteractorInterface {

}

extension RecipesListPresenter: RecipesListPresenterViewInterface {

    func start() {

    }

}
