//
//  RestConsumction.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift


//MARK: - DataDownloading
protocol DataDownloading {
    func download<T: Mappable>(type: T.Type, keyPath: String?, url: String, block: @escaping ([T])->(), error: @escaping (Int?) ->())
}

extension DataDownloading {
    
    func download<T: Mappable>(type: T.Type, keyPath: String?, url: String, block: @escaping ([T])->(), error: @escaping (Int?) ->()) {
        let backgroundQueueForREST = DispatchQueue(label: "com.app.queueForRest", qos: .background, target: nil)
        
        Alamofire.request(url).responseArray(queue: backgroundQueueForREST, keyPath: keyPath, context: nil, completionHandler: { (response: DataResponse<[T]>) in
            switch response.result {
            case .success(let value):
                block(value)
            case .failure(_):
                let responseCode = response.response?.statusCode
                error(responseCode)
            }
        })
    }
}


//MARK: - PoznanGravesAPI
protocol PoznanGravesAPI: DataDownloading {
    func getAllGraves(block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->())
    func find(surname: String, block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->())
}

extension ViewController: PoznanGravesAPI {
    
    func getAllGraves(block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->()) {
        let url = "http://www.poznan.pl/featureserver/featureserver.cgi/groby/all.json"
        
        self.download(type: GraveModel.self, keyPath: "features", url: url, block: { model in
            block(model)
        }, error: { errorCode in
            error(errorCode)
        })
    }
    
    func find(surname: String, block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->()) {
        let url = "http://www.poznan.pl/featureserver/featureserver.cgi/groby?queryable=g_surname&g_surname=\(surname)"

        self.download(type: GraveModel.self, keyPath: "features", url: url, block: { model in
            block(model)
        }, error: { errorCode in
            error(errorCode)
        })
    }
}
