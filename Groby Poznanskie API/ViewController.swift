//
//  ViewController.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    //MARK: - variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!

    var arrayOfGraves: [GraveModel] = []
    
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        self.visualEffectView.addGestureRecognizer(tap)
        
        self.loadData()
    }

    func tapView(_ sender: UITapGestureRecognizer) {
        self.visualEffectView.isUserInteractionEnabled = false
        self.errorLabel.isHidden = true
        self.activityIndicatorView.startAnimating()
        self.loadData()
    }
    
    func loadData() {
        let graves = loadGraveModelFromRealm()
        if graves.count != 0 {
            self.arrayOfGraves = graves
            self.tableView.reloadData()
            self.visualEffectView.removeFromSuperview()
        } else {
            self.loadDataFromRemote()
        }
    
    }
    
    func loadDataFromRemote() {
        self.getData(block: { (graves:[GraveModel]) in
            DispatchQueue.main.async {
                self.arrayOfGraves = graves.filter({graveModel in
                    if graveModel.properties?.print_surname == "Rezerwacja" || graveModel.properties?.print_surname == "Puste" {
                        return false
                    }
                    return true
                })
                self.saveGravesInRealm(graveArray: self.arrayOfGraves)
                self.tableView.reloadData()
                self.visualEffectView.removeFromSuperview()
            }
        }, error: { (responseCode:Int?) in
            self.errorLabel.isHidden = false
            self.activityIndicatorView.stopAnimating()
            self.visualEffectView.isUserInteractionEnabled = true
        })
    }
    
    //MARK: - Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GraveDetails" {
            let vc = segue.destination as! GraveDetailsViewController
            vc.grave = sender as! GraveModel
        }
    }

}


//MARK: -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: UITableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfGraves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraveCell", for: indexPath) as! GraveTableViewCell
        cell.name.text = self.arrayOfGraves[indexPath.row].getFullName()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "GraveDetails", sender: self.arrayOfGraves[indexPath.row])
    }

}

