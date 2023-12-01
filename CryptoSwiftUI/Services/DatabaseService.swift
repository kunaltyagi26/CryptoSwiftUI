//
//  DatabaseService.swift
//  CryptoSwiftUI
//
//  Created by Kunal Tyagi on 29/11/23.
//

import CoreData
import Foundation

final class DatabaseService: ObservableObject {
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    
    @Published var savedEntites: [Portfolio] = []
    
    static var shared = DatabaseService()
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                print("Error loading core data: \(error)")
            } else {
                self?.fetch()
            }
        }
    }
    
    func updatePortfolio(coin: Coin, amount: Double, priceChangePercentage: Double = 0.0) {
        if let entity = savedEntites.first(where: { $0.id == coin.id }) {
            if priceChangePercentage != 0.0 {
                update(entity: entity, amount: amount, priceChangePercentage: priceChangePercentage)
            } else if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    private func fetch() {
        do {
            let fetchRequest = NSFetchRequest<Portfolio>(entityName: String(describing: Portfolio.self))
            savedEntites = try container.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.id = coin.id
        entity.amount = amount
        entity.price = coin.currentPrice
        entity.priceChangePercentage = coin.priceChangePercentage24H ?? 0.0
        
        applyChanges()
    }
    
    private func update(entity: Portfolio, amount: Double, priceChangePercentage: Double = 0.0) {
        entity.amount = amount
            
        if priceChangePercentage != 0.0 {
            entity.priceChangePercentage = priceChangePercentage
        }
            
        applyChanges()
    }
    
    private func remove(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to core data: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        fetch()
    }
}
