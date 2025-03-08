//
//  RegistrarEntrenamientoView.swift
//  GymTrack
//
//  Created by Sergio Comerón on 2/3/25.
//

import SwiftUI
import SwiftData

struct RegistrarEntrenamientoView: View {
    let ejercicio: Ejercicio
    @State private var repeticiones: String = ""
    @State private var peso: String = ""
    @State private var series: [Serie] = []
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section(header: Text("Agregar Serie")) {
                TextField("Repeticiones", text: $repeticiones)
                    .keyboardType(.numberPad)
                TextField("Peso", text: $peso)
                    .keyboardType(.decimalPad)
                Button("Añadir Serie") {
                    let pesoConPunto = peso.replacingOccurrences(of: ",", with: ".")
                    if let reps = Int(repeticiones),
                       let kg = Double(pesoConPunto) {
                        let nuevaSerie = Serie(repeticiones: reps, peso: kg, fecha: Date())
                        series.append(nuevaSerie)
                        repeticiones = ""
                        peso = ""
                    }
                }
            }
            
            Section(header: Text("Series Registradas")) {
                ForEach(series) { serie in
                    Text("\(serie.repeticiones) repeticiones - \(serie.peso, specifier: "%.2f") kg")
                }
            }
            
            Section {
                Button("Guardar Entrenamiento") {
                    let nuevoEntrenamiento = EjercicioEntrenamiento(
                        fecha: Date(),
                        ejercicio: ejercicio,
                        series: series
                    )
                    // Insertar el nuevo entrenamiento en el contexto de SwiftData
                    modelContext.insert(nuevoEntrenamiento)
                    
                    // Guardar el contexto. En una aplicación real podrías manejar posibles errores
                    do {
                        try modelContext.save()
                    } catch {
                        print("Error al guardar el entrenamiento: \(error)")
                    }
                    
                    // Cerrar el sheet
                    dismiss()
                }
            }
        }
        .navigationTitle(ejercicio.nombre)
    }
}

#Preview {
    let demoEjercicio = Ejercicio(
        nombre: "Press de Banca",
        descripcion: "Ejercicio para trabajar el pectoral mayor",
        grupoMuscular: "Pecho"
    )
    
    NavigationStack {
        RegistrarEntrenamientoView(ejercicio: demoEjercicio)
    }
}
