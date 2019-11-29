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
    func presentingFavoritesList(_ favorites: Bool) {
        view.presentingFavoritesList(favorites)
    }

    func recipeFetchedSuccess(recipes: Array<ModelRecipe>) {
        view.showRecipes(recipes: recipes)
    }

    func recipeFetchFailed(error: Error) {
        //not handled, as at some cases, the API is just unreliable
        //TODO: Point to Improve
    }

    func openDetailsFrom(url: URL, title: String) {
        router.pushToDetailScreen(using: url, title: title)
    }

    func openDetailsFrom(data: Data, baseURL: URL, title: String) {
        router.pushToDetailScreen(data: data, baseURL: baseURL, title: title)
    }
}

extension RecipesListPresenter: RecipesListPresenterViewInterface {
    func toggleFavoritesList() {
        interactor.toggleFavoritesList()
    }

    func toggleFavorite(recipe: ModelRecipe) {
        interactor.toggleFavorite(recipe: recipe)
    }

    func start() {
        interactor.loadInitialData()
    }

    func fetchMore() {
        interactor.fetchRecipes()
    }

    func openDetail(recipe: ModelRecipe) {
        interactor.openDetails(for: recipe)
    }

    func ingredientsChanged(_ ingredients: String) {
        if interactor.searchByIngredients(ingredients) {
            interactor.fetchRecipes()
        }
    }
}
