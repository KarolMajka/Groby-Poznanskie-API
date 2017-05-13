//
//  GraveDetailsViewController.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit

class GraveDetailsViewController: UITableViewController {
    
    //MARK: - variables
    var grave: GraveModel!
    let content:[[String:Any]] =
        [
            ["Title":"Dane",
            "Content":[
                ["Title":"Imię", "Details":"print_name"],
                ["Title":"Nazwisko", "Details":"print_surname"]
            ]
            ],
            ["Title":"Czas życia",
             "Content":[
                ["Title":"Data urodzenia", "Details":"g_date_birth"],
                ["Title":"Data zgonu", "Details":"g_date_death"],
                ["Title":"", "Details":"g_time_life"]
            ]],
             ["Title":"Miejsce grobu",
                "Content":[
                ["Title":"Kwatera", "Details":"g_quarter"],
                ["Title":"Miejsce", "Details":"g_place"],
                ["Title":"Rząd", "Details":"g_row"]
            ]]
        ]
    
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView?.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UITableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.content[section]["Content"] as! [[String:String]]).count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.content.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.content[section]["Title"] as? String
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraveDetailsCell", for: indexPath)
        
        let data = (self.content[indexPath.section]["Content"] as! [[String:String]])[indexPath.row]
        cell.textLabel?.text = data["Title"]
        cell.detailTextLabel?.text = self.getDetailsText(value: data["Details"]!)
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
            return self.grave.getTimeLifeString()
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
}
