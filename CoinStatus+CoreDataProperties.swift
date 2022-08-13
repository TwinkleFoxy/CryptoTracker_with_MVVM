//
//  CoinStatus+CoreDataProperties.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 17.07.2022.
//
//

import Foundation
import CoreData


extension CoinStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinStatus> {
        return NSFetchRequest<CoinStatus>(entityName: "CoinStatus")
    }

    @NSManaged public var name: String?
    @NSManaged public var isFavourite: Bool

}

extension CoinStatus : Identifiable {

}
