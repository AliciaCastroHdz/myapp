//
//  NetworkService.swift
//  FREESTYLE
//
//  Created by Alicia Monserrath Castro Hernandez on 30/10/20.
//

import Alamofire
import Foundation
import SwiftyJSON
import RxSwift

struct Strings {
    public static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    public static let searchPath = "search.php"
    public static let apiKey = "634b49e294bd1ff87914e7b9d014daed"
}

protocol IEndpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameter: Parameters? { get }
    var header: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

class NetworkService {
    static let share = NetworkService()
    private var dataRequest: DataRequest?
    private var success: ((_ data: Data?)->Void)?
    private var failure: ((_ error: Error?)->Void)?
    
    @discardableResult
    private func _dataRequest(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest {
            return SessionManager.default.request(
                url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
    }
    
    func getResponse<T: IEndpoint>(endpoint: T) -> Observable<JSON> {
        return Observable.create { observer in
            self.request(endpoint: endpoint, success: { responseData in
                if let json = try? JSON(data: responseData) {
                    observer.onNext(json)
                } else {
                    observer.onError(HttpNetworkingError.jsonSerializationFailed(HttpRequestError.parsingError.error))
                }
                observer.onCompleted()
            }, failure: { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onError(HttpNetworkingError.jsonSerializationFailed(HttpRequestError.parsingError.error))
                }
            })
            return Disposables.create()
        }
    }
    
    private func request<T: IEndpoint>(endpoint: T, success: ((_ data: Data)->Void)? = nil, failure: ((_ error: Error?)->Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            self.dataRequest = self._dataRequest(url: endpoint.path,
                                                 method: endpoint.method,
                                                 parameters: endpoint.parameter,
                                                 encoding: endpoint.encoding,
                                                 headers: endpoint.header)
            self.dataRequest?.responseData(completionHandler: { (response) in
                switch response.result {
                case .success (let value):
                    success?(value)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func cancelRequest(_ completion: (()->Void)? = nil) {
        dataRequest?.cancel()
        completion?()
    }
    
    func cancelAllRequest(_ completion: (()->Void)? = nil) {
        dataRequest?.session.getAllTasks(completionHandler: { (tasks) in
            tasks.forEach({ (task) in
                task.cancel()
            })
        })
        completion?()
    }
    
    func success(_ completion: ((_ data: Data?)->Void)?) -> NetworkService {
        success = completion
        return self
    }
    
    func failure(_ completion: ((_ error: Error?)->Void)?) -> NetworkService {
        failure = completion
        return self
    }
}
