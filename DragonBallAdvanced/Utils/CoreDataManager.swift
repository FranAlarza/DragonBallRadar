//
//  CoreDataManager.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 12/9/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func saveHeroes(with modelHero: Hero) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        let heroItem = PersistenceHeros(context: context)
        
        heroItem.name = modelHero.name
        heroItem.id = modelHero.id
        heroItem.descripcion = modelHero.description
        heroItem.favourite = modelHero.favorite
        heroItem.photo = modelHero.photo.absoluteString
        heroItem.latitud = modelHero.latitud ?? 0.0
        heroItem.longitud = modelHero.longitud ?? 0.0
        
        do {
            try context.save()
            print("Los datos se guardaron correctamente")
        } catch {
            print("Error de Guardado - \(error)")
        }
    }
    
    func fetchHeroes(predicate: NSPredicate? = nil, completion: (Result<[PersistenceHeros]?, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext

        
        var request: NSFetchRequest<PersistenceHeros>
        request = PersistenceHeros.fetchRequest()
        request.predicate = predicate
        
        do {
            let response = try context.fetch(request)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteEntity(entityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<PersistenceHeros>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            results.forEach { managedObject in
                let managedObjectData = managedObject as NSManagedObject
                context.delete(managedObjectData)
            }
        } catch {
            print("Delete Error")
        }
        
    }
}
