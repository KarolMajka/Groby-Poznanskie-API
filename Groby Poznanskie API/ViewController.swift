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
    
    let refreshControl = UIRefreshControl()
    var arrayOfGraves: [GraveModel] = []
    
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        self.visualEffectView.addGestureRecognizer(tap)
        self.addRefreshController()
        
        self.loadData()
    }

    
    func addRefreshController() {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.loadDataFromRemote(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
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
            self.loadDataFromRemote(nil)
        }
    
    }
    
    func loadDataFromRemote(_ sender: Any?) {
        self.tableView.isUserInteractionEnabled = false
        
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
                self.tableView.isUserInteractionEnabled = true
                if sender != nil {
                    self.refreshControl.endRefreshing()
                }
            }
        }, error: { (responseCode:Int?) in
            DispatchQueue.main.async {
                if sender != nil {
                    self.tableView.isUserInteractionEnabled = true
                    self.showAlert(title: "Groby Poznańskie", message: "Nieudało się pobrać nowych danych", action: { _ in
                        self.refreshControl.endRefreshing()
                    })
                } else {
                    self.errorLabel.isHidden = false
                    self.activityIndicatorView.stopAnimating()
                    self.visualEffectView.isUserInteractionEnabled = true
                }
            }
        })
    }
    
    func showAlert(title: String, message: String, action: ((UIAlertAction?) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: action))
            self.present(alert, animated: true, completion: nil)
        }
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

