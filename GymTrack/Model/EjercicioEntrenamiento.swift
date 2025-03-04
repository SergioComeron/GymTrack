//
//  EjercicioEntrenamiento.swift
//  GymTrack
//
//  Created by Sergio Comerón on 2/3/25.
//

import SwiftData
import Foundation

@Model
class EjercicioEntrenamiento: Identifiable {
    var id: UUID = UUID()
    var fecha: Date
    var ejercicio: Ejercicio
    var series: [Serie]
    
    init(fecha: Date, ejercicio: Ejercicio, series: [Serie] = []) {
        self.fecha = fecha
        self.ejercicio = ejercicio
        self.series = series
    }
}
