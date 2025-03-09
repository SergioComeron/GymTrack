//
//  SeriePlanificada.swift
//  GymTrack
//
//  Created by Sergio Comerón on 9/3/25.
//

import SwiftData
import Foundation

@Model
class SeriePlanificada: Identifiable {
    var id: UUID = UUID()
    var repeticiones: Int
    var pesoEstimado: Double?

    init(repeticiones: Int, pesoEstimado: Double? = nil) {
        self.repeticiones = repeticiones
        self.pesoEstimado = pesoEstimado
    }
}
