//
//  EjercicioSesion.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftData

@Model
class EjercicioSesion {
    var ejercicio: Ejercicio
    var series: Int
    var repeticiones: Int
    var peso: Double

    init(ejercicio: Ejercicio, series: Int, repeticiones: Int, peso: Double) {
        self.ejercicio = ejercicio
        self.series = series
        self.repeticiones = repeticiones
        self.peso = peso
    }
}
