//
//  JSONDecoder.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/24/21.
//

import Foundation

class Decoder {
    
    let dataLayer =  DataManager.sharedInstance
    
    func decodeAndSaveToCoreData() {
        
        do {
            if let file = Bundle.main.url(forResource: "Offers", withExtension: "json") {

                var offersList : [OfferData] = []
                // Decode to struct
                offersList = try JSONDecoder().decode([OfferData].self, from: try Data(contentsOf: file))
                
                for product in offersList {
                // Create CoreData entry
                    dataLayer.createProduct(id: product.id, url: product.url ?? "", name: product.name, descript: product.description, terms: product.terms, currentValue: product.current_value, isFavorite: false)
                }
            }
        } catch {
            print(error)
        }
    }
}
