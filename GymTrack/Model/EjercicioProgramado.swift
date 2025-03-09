//
//  EjercicioProgramado.swift
//  GymTrack
//
//  Created by Sergio Comerón on 9/3/25.
//

import SwiftData
import Foundation

@Model
class EjercicioProgramado: Identifiable {
    var id: UUID = UUID()
    var ejercicio: Ejercicio
    var orden: Int
    var seriesPlanificadas: [SeriePlanificada]

    init(ejercicio: Ejercicio, orden: Int, seriesPlanificadas: [SeriePlanificada]) {
        self.ejercicio = ejercicio
        self.orden = orden
        self.seriesPlanificadas = seriesPlanificadas
    }
}
