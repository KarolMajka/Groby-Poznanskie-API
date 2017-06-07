//
//  RealmManagement.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 31/05/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

extension ViewController {
    func loadGraveModelFromRealm() -> [GraveModel] {
        let realm = try! Realm()
        let realmObjects = realm.objects(GraveModel.self)
        return mapToModel(realmObjects: realmObjects)
    }

    private func mapToModel(realmObjects: Results<GraveModel>?) -> [GraveModel] {
        var graveArray: [GraveModel] = []
        if realmObjects == nil {
            return graveArray
        }
        for object in realmObjects! {
            graveArray.append(object)
        }
        
        return graveArray
    }

    func saveGravesInRealm(graveArray: [GraveModel]) {
        clearGravesTable()
        let realm = try! Realm()
        for grave in graveArray {
            let realmRow = grave
            //realmRow.geometry = grave.geometry
            //realmRow.id = grave.id
            //realmRow.properties = grave.properties

            try! realm.write {
                realm.add(realmRow)
                
            }
        }
    }

    private func clearGravesTable() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(GraveModel.self))
        }
    }
}
