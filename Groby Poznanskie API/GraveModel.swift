//
//  GraveModel.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class GraveModel: Object, Mappable {

    required convenience init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        self.init()
    }

    
    dynamic var geometry: GraveGeometryModel? = GraveGeometryModel()
    dynamic var id: Int = 0
    dynamic var properties: GravePropertiesModel? = GravePropertiesModel()
    

    func mapping(map: Map) {
        //let values = try! (map.value("geometry.coordinates") as! [[CGFloat]])
        geometry <- map["geometry"]
        id <- map["id"]
        properties <- map["properties"]
    }
    
    func getFullName() -> String {
        return self.properties!.print_surname + " " + self.properties!.print_name
    }
    
}

class GraveGeometryModel: Object, Mappable {
    dynamic var x: CGFloat = 0
    dynamic var y: CGFloat = 0
    dynamic var type: NSString = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        let values = (map.JSON["coordinates"] as! NSArray)[0] as! NSArray
        x = values[0] as! CGFloat
        y = values[1] as! CGFloat
        type <- map["type"]
    }
}

class GravePropertiesModel: Object, Mappable {
    dynamic var cm_id: Int = 0
    dynamic var cm_nr: Int = 0
    dynamic var g_date_birth: String = ""
    dynamic var g_date_burial: String = ""
    dynamic var g_date_death: String = ""
    dynamic var g_family: String = ""
    dynamic var g_field: String = ""
    dynamic var g_name: String = ""
    dynamic var g_place: String = ""
    dynamic var g_quarter: String = ""
    dynamic var g_row: String = ""
    dynamic var g_size: String = ""
    dynamic var g_surname: String = ""
    dynamic var g_surname_name: String = ""
    dynamic var paid: Int = 0
    dynamic var print_name: String = ""
    dynamic var print_surname: String = ""
    dynamic var print_surname_name: String = ""
    lazy var g_time_life: String = {
        return self.getTimeLifeString()
    }()

    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func ignoredProperties() -> [String] {
        return ["g_time_life"]
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

    func getTimeLifeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard
            let birthDate = formatter.date(from: self.g_date_birth),
            let deathDate = formatter.date(from: self.g_date_death) else {
                return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if dateFormatter.string(from: birthDate) == "01-01-0001" || dateFormatter.string(from: deathDate) == "01-01-0001" {
            return ""
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
        let yearString = self.getPartDateString(date: year, values:[NSLocalizedString("year1", comment: ""), NSLocalizedString("year2", comment: ""), NSLocalizedString("year3", comment: "")])
        let monthString = self.getPartDateString(date: month, values: [NSLocalizedString("month1", comment: ""), NSLocalizedString("month2", comment: ""), NSLocalizedString("month3", comment: "")])
        let dayString = self.getPartDateString(date: day, values: [NSLocalizedString("day1", comment: ""), NSLocalizedString("day2", comment: ""), NSLocalizedString("day3", comment: "")])
        var dateString = yearString
        if yearString != "" {
            if monthString != "" && dayString != "" {
                dateString += ", " + monthString + NSLocalizedString(" and ", comment: "") + dayString
            } else if monthString != "" {
                dateString += NSLocalizedString(" and ", comment: "") + monthString
            } else if dayString != "" {
                dateString += NSLocalizedString(" and ", comment: "") + dayString
            }
        } else {
            dateString = monthString
            if monthString != "" {
                if dayString != "" {
                    dateString += NSLocalizedString(" and ", comment: "") + dayString
                }
            } else {
                dateString = dayString
                if dayString == "" {
                    return NSLocalizedString("0 day", comment: "")
                }
            }
        }
        return dateString
    }
}
