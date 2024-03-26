//
//  PersonModel.swift
//  VKPlagueSimulationTest
//
//  Created by Ильнур Закиров on 22.03.2024.
//

import Foundation

struct Person: Hashable {
    let id: Int
    var isHealthy: Bool
    let address: (Int, Int)
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id &&
        lhs.address.0 == rhs.address.0 &&
        lhs.address.1 == rhs.address.1
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(address.0)
        hasher.combine(address.1)
    }
}
