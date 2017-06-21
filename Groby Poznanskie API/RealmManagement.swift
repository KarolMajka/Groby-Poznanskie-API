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

    func saveGravesInRealm(graveArray: [GraveModel]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(graveArray, update: true)
        }
    }

    func updateFavorite(grave: GraveModel) {
        let realm = try! Realm()
        try! realm.write {
            grave.favorite = !grave.favorite
            realm.add(grave, update: true)
        }
    }
    
    func clearGravesTable(expect graveArray: [GraveModel]) {
        let realm = try! Realm()
        let objectsToDelete = realm.objects(GraveModel.self).filter({ realmGrave in
                return !graveArray.contains(where: { realmGrave.id == $0.id })
            })
        if objectsToDelete.count != 0 {
            try! realm.write {
                realm.delete(objectsToDelete)
            }
        }
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

}
