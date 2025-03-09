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
    var orden: Int?

    init(repeticiones: Int, pesoEstimado: Double? = nil, orden: Int? = nil) {
        self.repeticiones = repeticiones
        self.pesoEstimado = pesoEstimado
        self.orden = orden
    }
}
