//
//  EjercicioJson.swift
//  GymTrack
//
//  Created by Sergio Comerón on 2/3/25.
//

import Foundation

struct EjercicioJSON: Decodable {
    let nombre: String
    let grupoMuscular: String
    let descripcion: String
}
