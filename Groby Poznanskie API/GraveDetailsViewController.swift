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
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView?.isHidden = true
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
        cell.detailTextLabel?.text = self.grave.properties?.value(forKey: data["Details"]!) as? String
        return cell
    }
}
