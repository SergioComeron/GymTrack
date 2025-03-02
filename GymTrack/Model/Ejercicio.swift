//
//  Ejercicio.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftData

@Model
class Ejercicio {
    var nombre: String
    var descripcion: String?
    var grupoMuscular: String?
    var seriesDefecto: Int
    var repeticionesDefecto: Int
    var pesoDefecto: Double

    init(nombre: String, descripcion: String? = nil, grupoMuscular: String? = nil,
         seriesDefecto: Int = 3, repeticionesDefecto: Int = 10, pesoDefecto: Double = 0.0) {
        self.nombre = nombre
        self.descripcion = descripcion
        self.grupoMuscular = grupoMuscular
        self.seriesDefecto = seriesDefecto
        self.repeticionesDefecto = repeticionesDefecto
        self.pesoDefecto = pesoDefecto
    }
}
