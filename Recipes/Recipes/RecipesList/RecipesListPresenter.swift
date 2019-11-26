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
    func pushToDetailScreen() {

    }

}

extension RecipesListPresenter: RecipesListPresenterInteractorInterface {
    func recipeFetchedSuccess(recipes: Array<ModelRecipe>) {
        view.showRecipes(recipes: recipes)
    }

    func recipeFetchFailed() {

    }


}

extension RecipesListPresenter: RecipesListPresenterViewInterface {

    func start() {
    }

    func fetchMore() {
        interactor.fetchRecipes()
    }

    func ingredientsChanged(_ ingredients: String) {
        if interactor.searchByIngredients(ingredients) {
            interactor.fetchRecipes()
        }
    }
}
