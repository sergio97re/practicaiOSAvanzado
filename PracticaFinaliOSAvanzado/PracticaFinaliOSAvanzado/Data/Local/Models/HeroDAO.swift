//
//  HeroDAO.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 04/01/2024.
//

import Foundation
import CoreData

@objc(HeroDAO)
class HeroDAO: NSManagedObject {
    static let entityName = "HeroDAO"
    
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var heroDescription: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
}
