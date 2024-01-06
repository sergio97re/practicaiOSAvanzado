//
//  Hero.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 04/01/2024.
//

import Foundation
import CoreData

typealias Heroes = [Hero]

struct Hero: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case isFavorite = "favorite"
    }
    
    let id: String?
    let name: String?
    let description: String?
    let photo: String?
    let isFavorite: Bool?
}

//MARK: - EXTENSION -
extension Hero: ManagedObjectConvertible {
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> HeroDAO? {
        let entityName = HeroDAO.entityName
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        
        let object = HeroDAO.init(entity: entityDescription, insertInto: context)
        object.id = id
        object.name = name
        object.photo = photo
        object.favorite = isFavorite ?? false
        return object
    }
}
