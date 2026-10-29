//
//  RecordMedicamentoDosagemView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import SwiftData

struct RecordMedicamentoDosagemView: View {
    
    @EnvironmentObject var manager: RecordMedicamentoCoordinatorManager
    @Environment(\.modelContext) var modelContext: ModelContext
    
    @State private var intervalSeleted: DoseInterval = .every15Minutes
    var medicamentoToSave: Medicamento
    
    @State private var showAlert: Bool = false
    
    init(medicamentoToSave: Medicamento) {
        self.medicamentoToSave = medicamentoToSave
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Intervalos") {
                    ForEach(DoseInterval.allCases) { interval in
                        Button {
                            intervalSeleted = interval
                            medicamentoToSave.intervalo = interval.label
                        } label: {
                            HStack {
                                Text(interval.label)
                                    .foregroundStyle(.black)
                                    .font(.callout)
                                Spacer()
                                if intervalSeleted.label == interval.label {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                }
                Section {
                    Button {
                        saveNotification(nameMedicine: medicamentoToSave.nome, interval: intervalSeleted.label, date: medicamentoToSave.timestamp)
                        
                    } label: {
                        Text("Salvar")
                            .padding(20)
                            .foregroundStyle(Color.black)
                            .background {
                                RoundedRectangle(cornerRadius: 50, style: .continuous)
                                    .fill(Color.yellow)
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Intevalo Dose")
        .alert("Error", isPresented: $showAlert) {
            VStack {
                Text("Error ao criar notificação!")
                Button("Fechar") {
                    showAlert = false
                }
            }
        }
    }
    
    private func saveNotification(nameMedicine: String, interval: String, date: Date) {
        if let doseEnum = DoseInterval.verify(dose: interval) {
            NotificationDelegate.createNotification(nameMedicine: nameMedicine, withTimeInvertal: TimeInterval(doseEnum.seconds))
            medicamentoToSave.startTriggerDate = Date()
            let segundosTreatment = (medicamentoToSave.quantidadeDias * 24) * 60 * 60
            medicamentoToSave.qtdDoses = segundosTreatment / doseEnum.seconds
            
            let calendar = Calendar(identifier: .gregorian)
            let nextDate = calendar.date(byAdding: doseEnum.components, to: medicamentoToSave.startTriggerDate ?? Date()) ?? Date()
            
            medicamentoToSave.nextDates = [medicamentoToSave.startTriggerDate ?? Date()]
            medicamentoToSave.nextDates?.append(nextDate)
            modelContext.insert(medicamentoToSave)
            manager.navigate(to: .confimation)
        } else {
           showAlert = true
        }
    }
}

#Preview {
    RecordMedicamentoDosagemView(medicamentoToSave: Medicamento(nome: "", dosagem: "", quantidadeDias: 0, timestamp: Date(), foto: Data(), intervalo: ""))
        .environmentObject(RecordMedicamentoCoordinatorManager())
}
