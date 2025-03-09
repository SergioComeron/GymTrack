//
//  EntrenamientoProgramado.swift
//  GymTrack
//
//  Created by Sergio Comerón on 9/3/25.
//

import SwiftData
import Foundation

@Model
class EntrenamientoProgramado: Identifiable {
    var id: UUID = UUID()
    var nombre: String
    var fechaCreacion: Date
    var ejerciciosProgramados: [EjercicioProgramado]
    
    init(nombre: String, fechaCreacion: Date = Date(), ejerciciosProgramados: [EjercicioProgramado] = []) {
        self.nombre = nombre
        self.fechaCreacion = fechaCreacion
        self.ejerciciosProgramados = ejerciciosProgramados
    }
}
