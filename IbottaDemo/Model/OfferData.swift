//
//  OffersData.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/22/21.
//

import Foundation

struct OfferData: Decodable {
    

    let id: String
    let url: String?
    let name: String
    let description: String
    let terms: String
    let current_value: String
    var isFavorite: Bool?
}
