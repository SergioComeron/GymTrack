//
//  Sesion.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftData
import Foundation

@Model
class Sesion {
    var fecha: Date
    var rutina: Rutina
    var ejerciciosRealizados: [EjercicioSesion]

    init(fecha: Date, rutina: Rutina, ejerciciosRealizados: [EjercicioSesion] = []) {
        self.fecha = fecha
        self.rutina = rutina
        self.ejerciciosRealizados = ejerciciosRealizados
    }
}
