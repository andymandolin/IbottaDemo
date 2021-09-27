//
//  CoreData.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/24/21.
//

import UIKit
import CoreData

class DataManager {

    static let sharedInstance = DataManager()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Create
    
    func createProduct(id: String, url: String, name: String, descript: String, terms: String, currentValue: String, isFavorite: Bool) {
        
        let newOffer = OfferObject(context: self.context)
        newOffer.id = id
        newOffer.url = url
        newOffer.name = name
        newOffer.descript = descript
        newOffer.terms = terms
        newOffer.currentValue = currentValue
        newOffer.isFavorite = isFavorite
        do {
            try self.context.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Retreive
    
    func fetchAllOffers() -> [OfferObject] {

        var arrOffers: [OfferObject] = []
        let fetchRequest = NSFetchRequest<OfferObject>(entityName: "OfferObject")
        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                Decoder().decodeAndSaveToCoreData()
                arrOffers = try context.fetch(fetchRequest)
            } else {
                arrOffers = result
            }
            return arrOffers
        } catch {
            print(error)
        }
        return arrOffers
    }
    
    func checkIsFavorite(product: NSManagedObject) -> Bool {
        
        var result = false
        let fetchedOffers: NSFetchRequest<OfferObject> = OfferObject.fetchRequest()
        let idLookup = product.value(forKey: "id") as? String
        fetchedOffers.predicate = NSPredicate(format: "id = %@", idLookup! as String)
        do {
            let results = try context.fetch(fetchedOffers)
            if results.count != 0 {
                result = results.first!.isFavorite
            }
        }
        catch {
            print(error)
        }
        return result
    }
    
    // MARK: - Update
    
    func updateFavorite(product: NSManagedObject) {
        
        var thisOffer: OfferObject!
        let offers: NSFetchRequest<OfferObject> = OfferObject.fetchRequest()
        let idLookup = product.value(forKey: "id") as? String
        offers.predicate = NSPredicate(format: "id = %@", idLookup! as String)
        
        do {
            let results = try context.fetch(offers)
            if results.count != 0 {
                thisOffer = results.first
                thisOffer.isFavorite =  !thisOffer.isFavorite
                try context.save()
            }
        }
        catch {
            print(error)
        }
    }
    
    // MARK: - Delete
    
    func delete(object: NSManagedObject) {
        var thisOffer: OfferObject!
        let offers: NSFetchRequest<OfferObject> = OfferObject.fetchRequest()
        let idLookup = object.value(forKey: "id") as? String
        offers.predicate = NSPredicate(format: "id = %@", idLookup! as String)
        
        do {
            let results = try context.fetch(offers)
            if results.count != 0 {
                thisOffer = results.first
                context.delete(thisOffer)
                try context.save()
            }
        }
        catch {
            print(error)
        }
    }
}

