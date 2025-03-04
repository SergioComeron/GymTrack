//
//  Serie.swift
//  GymTrack
//
//  Created by Sergio Comerón on 2/3/25.
//

import SwiftData
import Foundation

@Model
class Serie: Identifiable {
    var id: UUID = UUID()  // Para poder identificarlas en una lista
    var repeticiones: Int
    var peso: Double
    var fecha: Date?
    
    init(repeticiones: Int, peso: Double, fecha: Date?) {
        self.repeticiones = repeticiones
        self.peso = peso
        self.fecha = fecha
    }
}
