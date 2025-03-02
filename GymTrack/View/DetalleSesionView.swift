//
//  DetalleSesionView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI

struct DetalleSesionView: View {
    let sesion: Sesion

    var body: some View {
        List {
            ForEach(sesion.ejerciciosRealizados) { ejercicioSesion in
                VStack(alignment: .leading) {
                    Text(ejercicioSesion.ejercicio.nombre)
                    Text("Series: \(ejercicioSesion.series)")
                    Text("Repeticiones: \(ejercicioSesion.repeticiones)")
                    Text("Peso: \(ejercicioSesion.peso)")
                }
            }
        }
        .navigationTitle("Detalles de la Sesión")
    }
}
