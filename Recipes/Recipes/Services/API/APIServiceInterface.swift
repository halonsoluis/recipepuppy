//
//  APIServiceInterface.swift
//  Recipes
//
//  Created by Hugo Alonso on 28/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation
import RxSwift

typealias APIResponse = ([ModelRecipe]?) -> Void
protocol APIServiceInterface {
    func fetchRecipes(ingredients: String, page: String, completionHandler: @escaping APIResponse)
}
