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
    
    func getFullName() -> String {
        return self.properties!.print_surname! + " " + self.properties!.print_name!
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

class GravePropertiesModel: NSObject, Mappable {
    var cm_id: Int?
    var cm_nr: Int?
    var g_date_birth: String?
    var g_date_burial: String?
    var g_date_death: String?
    var g_family: String?
    var g_field: String?
    var g_name: String?
    var g_place: String?
    var g_quarter: String?
    var g_row: String?
    var g_size: String?
    var g_surname: String?
    var g_surname_name: String?
    var paid: Int?
    var print_name: String?
    var print_surname: String?
    var print_surname_name: String?
    lazy var g_time_life: String? = {
        return self.getTimeLifeString()
    }()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cm_id <- map["cm_id"]
        cm_nr <- map["cm_nr"]
        g_date_birth <- map["g_date_birth"]
        g_date_burial <- map["g_date_burial"]
        g_date_death <- map["g_date_death"]
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
    
    func getTimeLifeString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard
            let birthDateString = self.g_date_birth,
            let deathDateString = self.g_date_death,
            let birthDate = formatter.date(from: birthDateString),
            let deathDate = formatter.date(from: deathDateString) else {
                return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if dateFormatter.string(from: birthDate) == "01-01-0001" || dateFormatter.string(from: deathDate) == "01-01-0001" {
            return nil
        }
        let calendar = Calendar.autoupdatingCurrent
        let date1 = calendar.startOfDay(for: birthDate)
        let date2 = calendar.startOfDay(for: deathDate)
        let components = calendar.dateComponents([.day, .month, .year], from: date1, to: date2)
        return self.getDateString(year: components.year!, month: components.month!, day: components.day!)
    }
    
    private func getPartDateString(date: Int, values: [String]) -> String {
        var value = ""
        
        if date == 0 {
            
        } else if date == 1 {
            value += "1 " + values[0]
        } else if date <= 4 {
            value += String(date) + " " + values[1]
        } else if date >= 22 {
            var tmp = date
            while tmp > 9 {
                tmp = tmp - Int(tmp/10)*10
            }
            if tmp == 2 || tmp == 3 || tmp == 4 {
                value += String(date) + " " + values[1]
            } else {
                value += String(date) + " " + values[2]
            }
        } else {
            value += String(date) + " " + values[2]
        }
        return value
    }
    
    private func getDateString(year: Int, month: Int, day: Int) -> String {
        let yearString = self.getPartDateString(date: year, values:["rok", "lata", "lat"])
        let monthString = self.getPartDateString(date: month, values: ["miesiąc", "miesiące", "miesięcy"])
        let dayString = self.getPartDateString(date: day, values: ["dzień", "dni", "dni"])
        var dateString = yearString
        if yearString != "" {
            if monthString != "" && dayString != "" {
                dateString += ", " + monthString + " i " + dayString
            } else if monthString != "" {
                dateString += " i " + monthString
            } else if dayString != "" {
                dateString += " i " + dayString
            }
        } else {
            dateString = monthString
            if monthString != "" {
                if dayString != "" {
                    dateString += " i " + dayString
                }
            } else {
                dateString = dayString
                if dayString == "" {
                    return "0 dni"
                }
            }
        }
        return dateString
    }
}

enum GeometryTypeEnum: String {
    case Point = "Point"
    case None = "None"
    
}
