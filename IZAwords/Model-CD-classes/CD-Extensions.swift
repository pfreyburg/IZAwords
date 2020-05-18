//
//  cd-cars.swift
//  IZA-CoreData-1
//
//  Created by Martin Hruby on 18/03/2020.
//  Copyright © 2020 Martin Hruby FIT. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MHCoreData

// --------------------------------------------------------------------
//
extension Identification {
    // allocCar(), allocCustomer()
    convenience init(initialized context: NSManagedObjectContext) {
        // nejprve designovany init nad entitou
        self.init(context: context)
        
        // ted se doplni par dat
        self.dateCreated = Date()
        self.idCode = UUID().uuidString
    }
}

// --------------------------------------------------------------------
//

extension Lekce : MHFetchable {
    public static var frcBasicKey: AttributeName { "name" }
    public static func _byId(id: String) -> NSPredicate{
        return NSPredicate(format: "idCode = %@", id)
    }
}

extension Slovicko : MHFetchable {
     public static var frcBasicKey: AttributeName { "cz" }
     public static func _byLekcePredicate(lekce : Lekce) -> NSPredicate{
        return NSPredicate(format: "lekce = %@", lekce)
    }
}

