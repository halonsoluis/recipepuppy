//
//  RecipesListInteractor.swift
//  Recipes
//
//  Created by Hugo Alonso Luis on 25/11/2019.
//

import Foundation
import VIPER

final class RecipesListInteractor: InteractorInterface {

    weak var presenter: RecipesListPresenterInteractorInterface!

    private var lastPageLoaded = 0
    private var recipes: [ModelRecipe] = []
    private var ingredients: String = ""

    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension RecipesListInteractor: RecipesListInteractorPresenterInterface {

    func searchByIngredients(_ ingredients: String) {
        self.ingredients =  ingredients
        lastPageLoaded = 0
        recipes = []
    }

    func fetchRecipes() {
        lastPageLoaded = lastPageLoaded + 1

        var components = URLComponents()
        components.scheme = "http"
        components.host = "recipepuppy.com"
        components.path = "/api"
        components.queryItems = [
            URLQueryItem(name: "i", value: ingredients),
            //URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "p", value: lastPageLoaded.description)
        ]

        guard let url = components.url else { return }

        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"

        let dataTask = session.dataTask(with: request as URLRequest,
                                        completionHandler: { [weak self] (data, response, error) -> Void in

            if (error != nil) {
                self?.presenter.recipeFetchFailed()
            } else {
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let data = data,
                    let jsonString = String(data: data, encoding: .utf8),
                    let jsonData = jsonString.data(using: .utf8)
                    else { return }


                guard let response = try? JSONDecoder().decode(RecipeEnvelope.self, from: jsonData) else { return }

                guard let strongSelf = self else { return }

                strongSelf.recipes.append(contentsOf: response.results)
                strongSelf.presenter.recipeFetchedSuccess(recipes: strongSelf.recipes)
            }
        })

        dataTask.resume()
    }


}
