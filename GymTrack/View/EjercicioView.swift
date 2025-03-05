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
    
    // Formateador de fecha con hora, minutos y segundos
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Ejemplo: "Mar 4, 2025"
        formatter.timeStyle = .medium // Ejemplo: "14:30:45"
        return formatter
    }()
    
    // Filtra y ordena los entrenamientos que correspondan al ejercicio actual por fecha
    var entrenamientosDelEjercicio: [EjercicioEntrenamiento] {
        entrenamientos
            .filter { $0.ejercicio === ejercicio }
            .sorted { $0.fecha > $1.fecha } // Orden descendente (más reciente primero)
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
                // Botón para marcar/desmarcar como favorito
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        ejercicio.esFavorito = !(ejercicio.esFavorito ?? false)
                    }
                }) {
                    Image(systemName: (ejercicio.esFavorito ?? false) ? "star.fill" : "star")
                        .foregroundColor((ejercicio.esFavorito ?? false) ? .yellow : .gray)
                        .scaleEffect((ejercicio.esFavorito ?? false) ? 1.2 : 1.0)
                }
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
                        Section(header: Text(dateFormatter.string(from: entrenamiento.fecha))) {
                            ForEach(entrenamiento.series.sorted { ($0.fecha ?? Date.distantPast) < ($1.fecha ?? Date.distantPast) }) { serie in
                                VStack(alignment: .leading, spacing: 4) {
                                    if let fecha = serie.fecha {
                                        Text("Fecha: \(dateFormatter.string(from: fecha))")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("Fecha: No disponible")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Text("\(serie.repeticiones) repeticiones - \(serie.peso, specifier: "%.2f") kg")
                                        .font(.body)
                                }
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
    // Configuración del contenedor y datos en un bloque auxiliar
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Ejercicio.self, EjercicioEntrenamiento.self, Serie.self, configurations: config)
        
        let context = container.mainContext
        
        let demoEjercicio = Ejercicio(
            nombre: "Press de Banca",
            descripcion: "Ejercicio para trabajar el pectoral mayor",
            grupoMuscular: "Pecho",
            esFavorito: false // Inicializamos como no favorito
        )
        context.insert(demoEjercicio)
        
        let entrenamiento = EjercicioEntrenamiento(
            fecha: Date(),
            ejercicio: demoEjercicio,
            series: [
                Serie(repeticiones: 12, peso: 80.0, fecha: Date()),
                Serie(repeticiones: 10, peso: 85.0, fecha: Calendar.current.date(byAdding: .minute, value: -1, to: Date())!),
                Serie(repeticiones: 15, peso: 75.0, fecha: nil) // Ejemplo con fecha nil
            ]
        )
        context.insert(entrenamiento)
        
        try? context.save()
        
        return container
    }()
    
    // La vista devuelta sin 'return' explícito
    NavigationStack {
        EjercicioView(ejercicio: Ejercicio(nombre: "Press de Banca", descripcion: "Ejercicio para trabajar el pectoral mayor", grupoMuscular: "Pecho"))
    }
    .modelContainer(container)
}
