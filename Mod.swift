//
//  Mod.swift
//  ProfitCars
//
//  Created by Анастасия Исакова on 18.06.2023.
//

import Foundation
import CoreData

public class Automobile: NSManagedObject {
    @NSManaged public var type: String
    @NSManaged public var brand: String
    @NSManaged public var model: String
    @NSManaged public var year: Int16
    @NSManaged public var cost: Double
    @NSManaged public var expenses: Double
    @NSManaged public var photos: NSObject?
}
