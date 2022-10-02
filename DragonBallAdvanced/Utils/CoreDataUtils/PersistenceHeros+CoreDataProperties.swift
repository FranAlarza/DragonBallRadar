//
//  PersistenceHeros+CoreDataProperties.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 25/9/22.
//
//

import Foundation
import CoreData


extension PersistenceHeros {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<PersistenceHeros> {
        return NSFetchRequest<PersistenceHeros>(entityName: "PersistenceHeros")
    }

    @NSManaged public var descripcion: String
    @NSManaged public var favourite: Bool
    @NSManaged public var id: String
    @NSManaged public var latitud: Double
    @NSManaged public var longitud: Double
    @NSManaged public var name: String
    @NSManaged public var photo: String

}

extension PersistenceHeros : Identifiable {

}
