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

extension PersitenceServiceInterface {
    private var persistenceThread: DispatchQueue { DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated) }

    func save(recipe: ModelRecipe, completionHandler: @escaping (Bool) -> Void) {
        persistenceThread.async {
            let result = self.save(recipe: recipe)
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    func remove(recipe: ModelRecipe, completionHandler: @escaping (Bool) -> Void) {
        persistenceThread.async {
            let result = self.remove(recipe: recipe)
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    func loadAll(completionHandler: @escaping ([ModelRecipe]) -> Void) {
        persistenceThread.async {
            let result = self.loadAll()
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
}
