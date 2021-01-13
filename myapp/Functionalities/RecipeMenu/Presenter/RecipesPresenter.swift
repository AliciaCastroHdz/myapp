//
//  RecipesPresenter.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import Foundation
import RxSwift
import SwiftyJSON
import ObjectMapper

protocol IRecipesPresenter: class {
    func showErrorAlert(title: String, msg: String?)
    func showResponse(response: [RecipeModel])
}

class RecipesPresenter {
    weak var view: IRecipesPresenter?

    init(view: IRecipesPresenter?) {
        self.view = view
    }

    func getRecipes(query: String) {
        let _ = self.getRecipesListResponse(query: query)
            .subscribe(
                onNext: { [weak self] response in
                    guard let weakSelf = self else { return }
                    weakSelf.view?.showResponse(response: response)
                }
            )
    }
    
    private func getRecipesListResponse(query: String) -> Observable<[RecipeModel]> {
        let observer: Observable<JSON> = NetworkService.share
            .getResponse(endpoint: RecipesServices.getRecipesList(query: query))
        return observer
            .flatMap { json -> Observable<[RecipeModel]> in
                guard let results = json["meals"].array else {
                    return Observable.error(HttpNetworkingError.jsonSerializationFailed(HttpRequestError.mappingError.error))
                }

                var recipes: [RecipeModel] = []
                for item in results  {
                    if let json = item.dictionaryObject,
                       let value = Mapper<RecipeModel>().map(JSON: json) {
                        recipes.append(value)
                    }
                }
                return Observable.just(recipes)
            }
            .catchError { _ in
                return Observable.just([])
            }
    }
}
