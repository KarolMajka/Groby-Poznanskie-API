//
//  GraveDetailsViewController.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit

class GraveDetailsViewController: UITableViewController {

    var grave: GraveModel!
    let content: [[String:String]] = [
        ["Title":"Imię", "Details":"print_name"],
        ["Title":"Nazwisko", "Details":"print_surname"],
        ["Title":"Data urodzenia", "Details":"g_date_birth"],
        ["Title":"Data zgonu", "Details":"g_date_death"],
        ["Title":"Czas życia", "Details":"g_time_life"],
        ["Title":"Numer kwatery", "Details":"g_quarter"],
        ["Title":"Numer miejsca", "Details":"g_place"],
        ["Title":"Numer rzędu", "Details":"g_row"]
                                      ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraveDetailsCell", for: indexPath)
        cell.textLabel?.text = self.content[indexPath.row]["Title"]

        cell.detailTextLabel?.text = self.getDetailsText(value: self.content[indexPath.row]["Details"]!)
        return cell
    }
    
    func getDetailsText(value: String) -> String? {
        switch(value) {
        case "print_name":
            return self.grave.properties?.print_name
        case "print_surname":
            return self.grave.properties?.print_surname
        case "g_date_birth":
            guard let date = self.grave.properties?.g_date_birth else {
                return "Nieznana"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: date)
            if dateString == "01-01-0001" {
                return "Nieznana"
            }
            return dateString
        case "g_date_death":
            guard let date = self.grave.properties?.g_date_death else {
                return "Nieznana"
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: date)
            if dateString == "01-01-0001" {
                return "Nieznana"
            }
            return dateString
        case "g_time_life":
            guard let birthDate = self.grave.properties?.g_date_birth,
                let deathDate = self.grave.properties?.g_date_death else {
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
        case "g_quarter":
            return self.grave.properties?.g_quarter
        case "g_place":
            return self.grave.properties?.g_place
        case "g_row":
            return self.grave.properties?.g_row
        default:
            return nil
            
        }
    }
    
    func getPartDateString(date: Int, values: [String]) -> String {
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
    
    func getDateString(year: Int, month: Int, day: Int) -> String {
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
