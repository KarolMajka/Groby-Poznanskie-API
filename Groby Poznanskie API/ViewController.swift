//
//  ViewController.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 12/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, ViewControllerProtocol {

    //MARK: - variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var gravesListLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!

    let tableViewManager: TableViewManager = TableViewManager()
    let refreshControl = UIRefreshControl()

    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubview(toFront: self.visualEffectView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        self.visualEffectView.addGestureRecognizer(tap)
        
        self.addRefreshController()
        self.tableViewManager.delegateMethod = self
        self.tableView.delegate = self.tableViewManager
        self.tableView.dataSource = self.tableViewManager
        self.searchBar.delegate = self.tableViewManager
        
        self.loadData()
    }

    func addRefreshController() {
        self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
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
            self.tableViewManager.arrayOfGraves = graves
            self.tableViewManager.filteredArrayOfGraves = graves
            self.tableView.reloadData()
            self.visualEffectView.isHidden = true
        } else {
            self.loadDataFromRemote(nil)
        }
    
    }
    
    func loadDataFromRemote(_ sender: Any?) {
        self.tableView.isUserInteractionEnabled = false
        
        self.getData(block: { (graves:[GraveModel]) in
            DispatchQueue.main.async {
                self.tableViewManager.arrayOfGraves = graves.filter({graveModel in
                    if graveModel.properties?.print_surname == "Rezerwacja" || graveModel.properties?.print_surname == "Puste" {
                        return false
                    }
                    return true
                })
                self.tableViewManager.filteredArrayOfGraves = self.tableViewManager.arrayOfGraves
                self.saveGravesInRealm(graveArray: self.tableViewManager.arrayOfGraves)
                self.tableView.reloadData()
                self.activityIndicatorView.stopAnimating()
                self.visualEffectView.isHidden = true
                self.tableView.isUserInteractionEnabled = true
                if sender != nil {
                    self.refreshControl.endRefreshing()
                }
            }
        }, error: { (responseCode:Int?) in
            DispatchQueue.main.async {
                if sender != nil {
                    self.tableView.isUserInteractionEnabled = true
                    self.showAlert(title: NSLocalizedString("Poznan Graves", comment: ""), message: NSLocalizedString("Unable to download new data", comment: ""), action: { _ in
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
    
    func resizeHeader(for scrollSize: CGFloat) {
        let newHeight = max(min(self.headerViewHeightConstraint.constant + scrollSize, 70), 35)
        self.headerViewHeightConstraint.constant = newHeight
        self.gravesListLabel.alpha = (newHeight - 35)/(70-35)
    }
    
    func hideKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    
    //MARK: - Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GraveDetails" {
            let vc = segue.destination as! GraveDetailsViewController
            vc.grave = sender as! GraveModel
        }
    }
    
    
    //MARK: - Protocol methods
    func showGraveDetails(grave: GraveModel) {
        self.hideKeyboard()
        self.performSegue(withIdentifier: "GraveDetails", sender: grave)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func cancelButtonTap() {
        self.searchBar.text = ""
        self.tableView.reloadData()
        self.hideKeyboard()
    }

    func find(surname: String) {
        self.hideKeyboard()
        self.activityIndicatorView.startAnimating()
        self.visualEffectView.isHidden = false
        self.find(surname: surname, block: { (graves:[GraveModel]) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.visualEffectView.isHidden = true
                self.tableViewManager.arrayOfGraves += graves.filter({ graveModel in
                    if graveModel.id == self.tableViewManager.arrayOfGraves.first(where:{ graveModel2 in
                        if graveModel.id == graveModel2.id {
                            return true
                        }
                        return false
                    })?.id {
                        return false
                    }
                    return true
                })
                self.tableViewManager.filteredArrayOfGraves = graves
                self.tableView.reloadData()
            }
        }, error: { (responseCode:Int?) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.showAlert(title: NSLocalizedString("Poznan Graves", comment: ""), message: NSLocalizedString("Unable to download new data", comment: ""), action: { _ in
                    self.visualEffectView.isHidden = true
                })
            }
        })
    }
    
    func didScroll(for scrollSize: CGFloat) {
        self.searchBar.resignFirstResponder()
        self.resizeHeader(for: scrollSize)
    }
    
    func showKeyboard() {
        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
        UIView.animate(withDuration: 0.3, animations: {
            self.resizeHeader(for: -40)
        })
    }
}
