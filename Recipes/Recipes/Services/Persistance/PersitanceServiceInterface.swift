//
//  PersitanceServiceInterface.swift
//  Recipes
//
//  Created by Hugo Alonso on 28/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

protocol PersitenceServiceInterface {
    func save(recipe: ModelRecipe) -> Bool
    func remove(recipe: ModelRecipe) -> Bool
    func loadAll() -> [ModelRecipe]
}
