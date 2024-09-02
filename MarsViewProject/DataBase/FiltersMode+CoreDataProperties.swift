//
//  FiltersMode+CoreDataProperties.swift
//  MarsViewProject
//
//  Created by Алина Лошакова on 02.09.2024.
//
//

import Foundation
import CoreData


extension FiltersMode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FiltersMode> {
        return NSFetchRequest<FiltersMode>(entityName: "FiltersMode")
    }

    @NSManaged public var roverName: String?
    @NSManaged public var cameraName: String?
    @NSManaged public var selectedDate: Date?

}

extension FiltersMode : Identifiable {

}

