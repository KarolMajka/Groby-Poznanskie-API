//
//  RestConsumction.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import Foundation
import Alamofire



func getData(block: @escaping ([GraveModel])->(), error: @escaping (Int?) ->()) {
    let backgroundQueueForREST = DispatchQueue(label: "com.app.queueForRest",qos: .background, target: nil)
    Alamofire.request("http://www.poznan.pl/featureserver/featureserver.cgi/groby/all.json").responseJSON(queue: backgroundQueueForREST, completionHandler: { response in
        
        let responseCode = response.response?.statusCode
        if responseCode == 200 {
            if let JSON = response.result.value   {
                var arrayOfGraves = [GraveModel]()

                let array = (JSON as! NSDictionary)["features"] as! NSArray
                print(array[0])
                
                return
            }
        }
        error(responseCode)
    })
}
