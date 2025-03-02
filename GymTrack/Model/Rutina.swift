//
//  Rutina.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftData

@Model
class Rutina {
    var nombre: String
    var descripcion: String?
    var ejercicios: [Ejercicio]

    init(nombre: String, descripcion: String? = nil, ejercicios: [Ejercicio] = []) {
        self.nombre = nombre
        self.descripcion = descripcion
        self.ejercicios = ejercicios
    }
}
