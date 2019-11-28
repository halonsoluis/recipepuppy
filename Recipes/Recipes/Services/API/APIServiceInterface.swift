//
//  APIServiceInterface.swift
//  Recipes
//
//  Created by Hugo Alonso on 28/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

typealias APIResponse = ([RecipeData]?) -> Void
protocol APIServiceInterface {
    func fetchRecipes(ingredients: String, page: String, completionHandler: @escaping APIResponse)
}
