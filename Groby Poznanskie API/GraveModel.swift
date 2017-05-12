//
//  GraveModel.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import Foundation
import ObjectMapper

class GraveModel: Mappable {
    var geometry: GraveGeometryModel?
    var id: Int?
    var properties: GravePropertiesModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        geometry <- map["geometry"]
        id <- map["id"]
        properties <- map["properties"]
    }
    
}

class GraveGeometryModel: Mappable {
    var coordinates: CGPoint?
    var type: GeometryTypeEnum?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        let values = (map.JSON["coordinates"] as! NSArray)[0] as! NSArray
        coordinates = CGPoint(x: values[0] as! CGFloat, y: values[1] as! CGFloat)
        type <- (map["type"], EnumTransform<GeometryTypeEnum>())
    }
}

class GravePropertiesModel: Mappable {
    var cm_id: Int?
    var cm_nr: Int?
    var g_date_birth: Date?
    var g_date_burial: Date?
    var g_date_death: Date?
    var g_family: String?
    var g_field: String?
    var g_name: String?
    var g_place: String?
    var g_quarter: String?
    var g_row: Int?
    var g_size: String?
    var g_surname: String?
    var g_surname_name: String?
    var paid: Int?
    var print_name: String?
    var print_surname: String?
    var print_surname_name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cm_id <- map["cm_id"]
        cm_nr <- map["cm_nr"]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        g_date_birth <- (map["g_date_birth"], DateFormatterTransform(dateFormatter: formatter))
        g_date_burial <- (map["g_date_burial"], DateFormatterTransform(dateFormatter: formatter))
        g_date_death <- (map["g_date_death"], DateFormatterTransform(dateFormatter: formatter))
        g_family <- map["g_family"]
        g_field <- map["g_field"]
        g_name <- map["g_name"]
        g_place <- map["g_place"]
        g_quarter <- map["g_quarter"]
        g_row <- map["g_row"]
        g_size <- map["g_size"]
        g_surname <- map["g_surname"]
        g_surname_name <- map["g_surname_name"]
        paid <- map["paid"]
        print_name <- map["print_name"]
        print_surname <- map["print_surname"]
        print_surname_name <- map["print_surname_name"]
    }
}

enum GeometryTypeEnum: String {
    case Point = "Point"
    case None = "None"
    
}
