//
//  TableViewManager.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 07/06/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit

class TableViewManager: NSObject, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: - Variables
    var arrayOfGraves: [GraveModel] = []
    var filteredArrayOfGraves: [GraveModel] = []
    var delegateMethod: ViewControllerDelegate!
    var tableView: UITableView!
    var previousPointY: CGFloat = 0
    
    init(_ tableView: UITableView, searchBar: UISearchBar?, delegateMethod: ViewControllerDelegate) {
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar?.delegate = self
        self.tableView = tableView

        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.addGestureRecognizer(tap)
        
        self.delegateMethod = delegateMethod
    }
    
    
    //MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArrayOfGraves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GraveCell", for: indexPath) as! GraveTableViewCell
        cell.name.text = self.filteredArrayOfGraves[indexPath.row].getFullName()
        cell.star.set(fill: self.filteredArrayOfGraves[indexPath.row].favorite)
        
        let backgroundSelectionView = UIView()
        backgroundSelectionView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        cell.selectedBackgroundView = backgroundSelectionView

        return cell
    }
    
    func tableTapped(tap: UITapGestureRecognizer) {
        let location = tap.location(in: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: location) else {
            return
        }
        if location.x >= 8 && location.x <= 70 {
            self.delegateMethod.toggleFavorite(grave: self.filteredArrayOfGraves[indexPath.row], indexPath: indexPath)
            
        } else if location.x > 75 {
            self.tableView(self.tableView, didSelectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegateMethod.showGraveDetails(grave: self.filteredArrayOfGraves[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            self.delegateMethod.didScroll(for: (self.previousPointY-scrollView.contentOffset.y)/5)
            self.previousPointY = scrollView.contentOffset.y
        }
    }
    
    
    //MARK: - UISearchView
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.delegateMethod.showKeyboard()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredArrayOfGraves = self.arrayOfGraves
        self.delegateMethod.cancelButtonTap()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.delegateMethod.find(surname: searchBar.text!.lowercased())
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredArrayOfGraves = self.arrayOfGraves
        } else {
            self.filteredArrayOfGraves = self.arrayOfGraves.filter({ graveModel in
                if graveModel.properties!.g_surname.lowercased().contains(searchText.lowercased()) {
                    return true
                }
                return false
            })
        }
        self.delegateMethod.reloadData()
    }
}
