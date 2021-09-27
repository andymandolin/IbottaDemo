//
//  OffersObject+CoreDataProperties.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/24/21.
//
//

import Foundation
import CoreData


extension OfferObject {    

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfferObject> {
        return NSFetchRequest<OfferObject>(entityName: "OfferObject")
    }

    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var name: String?
    @NSManaged public var descript: String?
    @NSManaged public var terms: String?
    @NSManaged public var currentValue: String?
    @NSManaged public var isFavorite: Bool

}

extension OfferObject : Identifiable {

}
