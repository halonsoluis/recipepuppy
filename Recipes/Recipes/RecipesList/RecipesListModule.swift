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

}

protocol RecipesListPresenterInteractorInterface: PresenterInteractorInterface {

}

protocol RecipesListPresenterViewInterface: PresenterViewInterface {
    func start()
}

// MARK: - interactor

protocol RecipesListInteractorPresenterInterface: InteractorPresenterInterface {

}

// MARK: - view

protocol RecipesListViewPresenterInterface: ViewPresenterInterface {

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
