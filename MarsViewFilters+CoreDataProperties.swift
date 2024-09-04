//
//  MarsViewFilters+CoreDataProperties.swift
//  MarsViewProject
//
//  Created by Алина Лошакова on 04.09.2024.
//
//

import Foundation
import CoreData


extension MarsViewFilters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarsViewFilters> {
        return NSFetchRequest<MarsViewFilters>(entityName: "MarsViewFilters")
    }

    @NSManaged public var nameRover: String?
    @NSManaged public var nameCamera: String?
    @NSManaged public var selectedDate: Date?

}

extension MarsViewFilters : Identifiable {

}
