//
//  RecipesServices.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import SwiftyJSON


public enum RecipesServices: IEndpoint {
    case getDetails(id: String)
    case getRandomImage
    case getRecipesList(query: String)

    public var description: String {
        return "RecipesServices"
    }

    public var isAuth: Bool {
        switch self {
        case .getDetails, .getRandomImage, .getRecipesList:
            return true
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDetails, .getRandomImage, .getRecipesList:
            return .get
        }
    }

    var parameter: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .getDetails(let id):
            params["i"] = id
        case .getRandomImage:
            break
        case .getRecipesList(let query):
            params["s"] = query
        }

        return params
    }

    var header: HTTPHeaders? {
        return nil
    }

    var encoding: ParameterEncoding  {
        switch self {
        case .getDetails, .getRandomImage, .getRecipesList:
            return URLEncoding.default
        }
    }

    var path: String {
        let path: String
        switch self {
        case .getDetails:
            path = "lookup.php"
        case .getRandomImage:
            path = "random.php"
        case .getRecipesList:
            path = "search.php"
        }
        print("path: ", Strings.baseURL + path)
        return Strings.baseURL + path
    }
}
