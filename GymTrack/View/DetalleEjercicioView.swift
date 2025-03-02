//
//  DetalleEjercicioView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//

import SwiftUI
import SwiftData

struct DetalleEjercicioView: View {
    let ejercicio: Ejercicio

    var body: some View {
        Form {
            Section(header: Text("Información")) {
                Text("Nombre: \(ejercicio.nombre)")
                if let descripcion = ejercicio.descripcion {
                    Text("Descripción: \(descripcion)")
                }
                if let grupoMuscular = ejercicio.grupoMuscular {
                    Text("Grupo Muscular: \(grupoMuscular)")
                }
                Text("Series por defecto: \(ejercicio.seriesDefecto)")
                Text("Repeticiones por defecto: \(ejercicio.repeticionesDefecto)")
                Text("Peso por defecto: \(ejercicio.pesoDefecto)")
            }
        }
        .navigationTitle(ejercicio.nombre)
    }
}
