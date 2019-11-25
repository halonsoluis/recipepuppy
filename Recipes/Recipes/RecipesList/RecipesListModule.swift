//
//  RecipesListModule.swift
//  Recipes
//
//  Created by Hugo Alonso Luis on 25/11/2019.
//
import Foundation
import VIPER
import UIKit

// MARK: - router

protocol RecipesListRouterPresenterInterface: RouterPresenterInterface {

}

// MARK: - presenter

protocol RecipesListPresenterRouterInterface: PresenterRouterInterface {
    func pushToDetailScreen()
}

protocol RecipesListPresenterInteractorInterface: PresenterInteractorInterface {
    func recipeFetchedSuccess(recipes:Array<ModelRecipe>)
    func recipeFetchFailed()
}

protocol RecipesListPresenterViewInterface: PresenterViewInterface {
    func start()
    func fetchMore()
    func ingredientsChanged(_ ingredients: String)
}

// MARK: - interactor

protocol RecipesListInteractorPresenterInterface: InteractorPresenterInterface {
    func fetchRecipes()
    func searchByIngredients(_ ingredients: String)
}

// MARK: - view

protocol RecipesListViewPresenterInterface: ViewPresenterInterface {
    func showRecipes(recipes:Array<ModelRecipe>)
    func showError()
}


// MARK: - module builder

final class RecipesListModule: ModuleInterface {

    typealias View = RecipesListView
    typealias Presenter = RecipesListPresenter
    typealias Router = RecipesListRouter
    typealias Interactor = RecipesListInteractor

    func build() -> UIViewController {
        let view = View()
        let interactor = Interactor()
        let presenter = Presenter()
        let router = Router()

        self.assemble(view: view, presenter: presenter, router: router, interactor: interactor)

        router.viewController = view

        return view
    }
}
