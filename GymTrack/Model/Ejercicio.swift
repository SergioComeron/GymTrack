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
    var esFavorito: Bool? // Cambiado a opcional
    var imagenNombre: String? // Nueva propiedad opcional
    
    init(nombre: String, descripcion: String? = nil, grupoMuscular: String? = nil, esFavorito: Bool? = nil, imagenNombre: String? = nil) {
        self.nombre = nombre
        self.descripcion = descripcion
        self.grupoMuscular = grupoMuscular
        self.esFavorito = esFavorito
        self.imagenNombre = imagenNombre
    }
}
