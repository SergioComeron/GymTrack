//
//  EjercicioView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 2/3/25.
//

import SwiftUI
import SwiftData

struct EjercicioView: View {
    let ejercicio: Ejercicio // Recibe el ejercicio seleccionado
    @State private var mostrarSheet: Bool = false
    @Query private var entrenamientos: [EjercicioEntrenamiento]
    
    // Filtra los entrenamientos que correspondan al ejercicio actual
    var entrenamientosDelEjercicio: [EjercicioEntrenamiento] {
        entrenamientos.filter { $0.ejercicio === ejercicio }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Datos del ejercicio
            HStack {
                if let grupoMuscular = ejercicio.grupoMuscular {
                    Text("Grupo Muscular: \(grupoMuscular)")
                        .font(.headline)
                }
                Spacer()
            }
            HStack {
                if let descripcion = ejercicio.descripcion {
                    Text(descripcion)
                        .font(.body)
                }
                Spacer()
            }
            
            // Historial de entrenamientos
            Text("Historial de Entrenamientos")
                .font(.title3)
                .padding(.top)
            
            if !entrenamientosDelEjercicio.isEmpty {
                List {
                    ForEach(entrenamientosDelEjercicio) { entrenamiento in
                        Section(header: Text(entrenamiento.fecha, style: .date)) {
                            ForEach(entrenamiento.series) { serie in
                                Text("\(serie.repeticiones) repeticiones - \(serie.peso, specifier: "%.2f") kg")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            } else {
                Text("No hay entrenamientos registrados para este ejercicio.")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Botón para registrar un nuevo entrenamiento
            Button("Registrar Entrenamiento") {
                mostrarSheet = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle(ejercicio.nombre)
        .sheet(isPresented: $mostrarSheet) {
            NavigationStack {
                RegistrarEntrenamientoView(ejercicio: ejercicio)
            }
        }
    }
}

#Preview {
    let demoEjercicio = Ejercicio(
        nombre: "Press de Banca",
        descripcion: "Ejercicio para trabajar el pectoral mayor",
        grupoMuscular: "Pecho"
    )
    
    NavigationStack {
        EjercicioView(ejercicio: demoEjercicio)
    }
}
