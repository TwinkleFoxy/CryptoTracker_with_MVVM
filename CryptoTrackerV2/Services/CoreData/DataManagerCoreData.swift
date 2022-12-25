//
//  DataManagerCoreData.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 17.07.2022.
//

import Foundation
import CoreData

class DataManagerCoreData {

    static let shared = DataManagerCoreData()

    private init() {}

    private let context = CoreDataStack.shared.persistentContainer.viewContext

    //MARK: - Attention!: A coin whose status will be set to false will be deleted from the database
    func setFavouriteStatus(for coinName: String, with status: Bool) {
        let featchRequest: NSFetchRequest<CoinStatus> = CoinStatus.fetchRequest()
        featchRequest.predicate = NSPredicate(format: "name == %@", coinName)

        do {
            let responce = try context.fetch(featchRequest)
            if responce.isEmpty {
                let favouriteCoin = CoinStatus(context: context)
                favouriteCoin.name = coinName
                favouriteCoin.isFavourite = status
                try context.save()
            } else {
                guard let favouriteCoin = responce.first else { return }
                favouriteCoin.isFavourite = status
                //MARK: - Attention!: A coin whose status will be set to false will be deleted from the database 2. These two lines
                favouriteCoin.isFavourite == false ? context.delete(favouriteCoin) : print("No this favourite coin to delete is BD")
                try context.save()
            }
        } catch let error as NSError {
            print("CoreData Error: \(error.localizedDescription)")
        }
    }

    func getFavouriteStatus(for coinName: String) -> Bool {
        let featchReuest: NSFetchRequest<CoinStatus> = CoinStatus.fetchRequest()
        featchReuest.predicate = NSPredicate(format: "name == %@", coinName)

        do {
            let responce = try context.fetch(featchReuest)
            if responce.isEmpty {
                return false
            } else {
                let favouriteCoin = responce.first
                guard let favouriteStatus = favouriteCoin?.isFavourite else { return false }
                return favouriteStatus
            }
        } catch let error as NSError {
            print("CoreDate Error: \(error.localizedDescription)")
        }
        return false
    }
}

