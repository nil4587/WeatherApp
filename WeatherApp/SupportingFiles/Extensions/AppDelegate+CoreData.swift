//
//  AppDelegate+CoreData.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import Foundation
import CoreData

extension AppDelegate {
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Core Data Saving support
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(location: LocationModel) {
        let entityName = "Location"
        let latitudeKey = "lat", longitudeKey = "lon"
        let nameKey = "name", countryKey = "country", stateKey = "state"
        let managedContext = self.persistentContainer.viewContext
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            let planetPredicate = NSPredicate(format: "name contains[c] %@ AND state contains[c] %@ AND country contains[c] %@", location.name?.trimmedString ?? "", location.state?.trimmedString ?? "", location.country?.trimmedString ?? "")
            fetchRequest.predicate = planetPredicate
            let objects = try managedContext.fetch(fetchRequest)
            if objects.isEmpty {
                if let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) {
                    let searchTermObject = NSManagedObject(entity: entity, insertInto: managedContext)
                    searchTermObject.setValue(location.name?.trimmedString, forKey: nameKey)
                    searchTermObject.setValue(location.country?.trimmedString, forKey: countryKey)
                    searchTermObject.setValue(location.state?.trimmedString, forKey: stateKey)
                    searchTermObject.setValue(location.lat, forKey: latitudeKey)
                    searchTermObject.setValue(location.lon, forKey: longitudeKey)
                }
                if managedContext.hasChanges {
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        #if DEBUG
                        print("Could not save, \(error), \(error.userInfo)")
                        #endif
                    }
                }
            }
        } catch let error as NSError {
            #if DEBUG
                print("Could not save, \(error), \(error.userInfo)")
            #endif
        }
    }
    
    func fetchLocationData() -> [LocationModel]? {
        let entityName = "Location"
        let latitudeKey = "lat", longitudeKey = "lon"
        let nameKey = "name", countryKey = "country", stateKey = "state"
        
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: nameKey, ascending: true)]
        do {
            let locations: [LocationModel] = try managedContext.fetch(fetchRequest).compactMap({ object in
                let location = LocationModel(name: object.value(forKey: nameKey) as? String,
                                             local_names: nil,
                                             country: object.value(forKey: countryKey) as? String,
                                             state: object.value(forKey: stateKey) as? String,
                                             lat: object.value(forKey: latitudeKey) as? Double,
                                             lon: object.value(forKey: longitudeKey) as? Double)
                return location
            })
            return locations
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
