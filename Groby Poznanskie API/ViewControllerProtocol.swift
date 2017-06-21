//
//  ViewControllerProtocol.swift
//  Groby Poznanskie API
//
//  Created by Karol Majka on 07/06/2017.
//  Copyright © 2017 karolmajka. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
    func showGraveDetails(grave: GraveModel)
    func toggleFavorite(grave: GraveModel, indexPath: IndexPath)
    func reloadData()
    func cancelButtonTap()
    func find(surname: String)
    func showKeyboard()
    func didScroll(for scrollSize: CGFloat)
}
