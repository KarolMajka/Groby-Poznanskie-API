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
import RealmSwift

extension ViewController {

    func getData(block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->()) {
        let backgroundQueueForREST = DispatchQueue(label: "com.app.queueForRest",qos: .background, target: nil)
        let url = "http://www.poznan.pl/featureserver/featureserver.cgi/groby/all.json"
        
        Alamofire.request(url).responseArray(queue: backgroundQueueForREST, keyPath: "features", context: nil, completionHandler: { (response: DataResponse<[GraveModel]>) in
            
            let responseCode = response.response?.statusCode
            if responseCode == 200, let JSON = response.result.value {
                block(JSON)
            } else {
                error(responseCode)
            }
        })
    }
    
    func find(surname: String, block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->()) {
        let backgroundQueueForREST = DispatchQueue(label: "com.app.queueForRest",qos: .background, target: nil)
        let url = "http://www.poznan.pl/featureserver/featureserver.cgi/groby?queryable=g_surname&g_surname=\(surname)"
        
        Alamofire.request(url).responseArray(queue: backgroundQueueForREST, keyPath: "features", context: nil, completionHandler: { (response: DataResponse<[GraveModel]>) in
            
            let responseCode = response.response?.statusCode
            if responseCode == 200, let JSON = response.result.value {
                block(JSON)
            } else {
                error(responseCode)
            }
        })
    }
}
