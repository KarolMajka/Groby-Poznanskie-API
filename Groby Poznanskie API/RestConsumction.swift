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

func getData(block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->()) {
    let backgroundQueueForREST = DispatchQueue(label: "com.app.queueForRest",qos: .background, target: nil)
    let url = "http://www.poznan.pl/featureserver/featureserver.cgi/groby/all.json"
    
    
    Alamofire.request(url).responseArray(queue: backgroundQueueForREST, keyPath: "features", context: nil, completionHandler: { (response: DataResponse<[GraveModel]>) in
        
        let responseCode = response.response?.statusCode
        if responseCode == 200 {
            if let JSON = response.result.value   {
                block(JSON)
                return
            }
        }
        error(responseCode)
    })
}
