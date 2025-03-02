//
//  HistorialSesionesView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 1/3/25.
//
import SwiftUI
import SwiftData

struct HistorialSesionesView: View {
    @Query private var sesiones: [Sesion]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sesiones) { sesion in
                    NavigationLink(destination: DetalleSesionView(sesion: sesion)) {
                        Text(sesion.fecha, style: .date)
                    }
                }
            }
            .navigationTitle("Historial de Sesiones")
        }
    }
}
