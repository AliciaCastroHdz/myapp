//
//  RecipeDetailsPresenter.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import Foundation
import RxSwift
import SwiftyJSON
import ObjectMapper

protocol IRecipeDetailsPresenter: class {
    func showErrorAlert(title: String, msg: String?)
    func showResponse(response: RecipeModel)
}

class RecipeDetailsPresenter {
    weak var view: IRecipeDetailsPresenter?

    init(view: IRecipeDetailsPresenter?) {
        self.view = view
    }

    func getDetails(id: String) {
        let _ = self.getDetailsResponse(id: id)
            .subscribe(
                onNext: { [weak self] response in
                    guard let weakSelf = self else { return }
                    weakSelf.view?.showResponse(response: response)
                }
            )
    }

    private func getDetailsResponse(id: String) -> Observable<RecipeModel> {
        let observer: Observable<JSON> = NetworkService.share.getResponse(endpoint: RecipesServices.getDetails(id: id))
        return observer
            .flatMap { json -> Observable<RecipeModel> in
                guard let json = json.dictionaryObject,
                   let recipe = Mapper<RecipeModel>().map(JSON: json) else {
                    return Observable.error(HttpNetworkingError.jsonSerializationFailed(HttpRequestError.mappingError.error))
                }

                return Observable.just(recipe)
            }
            .catchError { _ in
                return Observable.error(HttpNetworkingError.notResponse)
            }
    }
}
