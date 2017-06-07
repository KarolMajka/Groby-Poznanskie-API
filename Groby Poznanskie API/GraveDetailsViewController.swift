//
//  GraveDetailsViewController.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit

class GraveDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - variables
    @IBOutlet var tableView: UITableView!
    
    var grave: GraveModel!
    let content:[[String:Any]] =
        [
            ["Title":NSLocalizedString("Data", comment: ""),
            "Content":[
                ["Title":NSLocalizedString("Name", comment: ""), "Details":"properties.print_name"],
                ["Title":NSLocalizedString("Surname", comment: ""), "Details":"properties.print_surname"]
            ]
            ],
            ["Title":NSLocalizedString("Time Life", comment: ""),
             "Content":[
                ["Title":NSLocalizedString("Birth Date", comment: ""), "Details":"properties.g_date_birth"],
                ["Title":NSLocalizedString("Death Date", comment: ""), "Details":"properties.g_date_death"],
                ["Title":"", "Details":"properties.g_time_life"]
            ]],
             ["Title":NSLocalizedString("Grave Place", comment: ""),
                "Content":[
                ["Title":NSLocalizedString("Quarter", comment: ""), "Details":"properties.g_quarter"],
                ["Title":NSLocalizedString("Place", comment: ""), "Details":"properties.g_place"],
                ["Title":NSLocalizedString("Row", comment: ""), "Details":"properties.g_row"]
            ]]
        ]
    
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView?.isHidden = true
    }

    //MARK: - IBActions
    @IBAction func backTap() {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    //MARK: - UITableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.content[section]["Content"] as! [[String:String]]).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.content[section]["Title"] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraveDetailsCell", for: indexPath)
        
        let data = (self.content[indexPath.section]["Content"] as! [[String:String]])[indexPath.row]
        cell.textLabel?.text = data["Title"]
        cell.detailTextLabel?.text = self.grave.value(forKeyPath: data["Details"]!) as? String
        return cell
    }
}
