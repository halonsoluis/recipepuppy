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
        threadSafe(action: { self.save(recipe: recipe) }) { completionHandler($0) }
    }

    func remove(recipe: ModelRecipe, completionHandler: @escaping (Bool) -> Void) {
        threadSafe(action: { self.remove(recipe: recipe) }) { completionHandler($0) }
    }

    func loadAll(completionHandler: @escaping ([ModelRecipe]) -> Void) {
        threadSafe(action: { self.loadAll() }) { completionHandler($0) }
    }

    private func threadSafe<ResultType>(action: @escaping () -> ResultType, completionHandler: @escaping (ResultType) -> Void) {
        persistenceThread.async {
            let result = action()
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
}
