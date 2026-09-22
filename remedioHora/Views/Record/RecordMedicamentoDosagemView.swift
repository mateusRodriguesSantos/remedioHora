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
    
    @State private var doseSeleted: DoseInterval = .every15Minutes
    var medicamentoToSave: Medicamento
    
    init(medicamentoToSave: Medicamento) {
        self.medicamentoToSave = medicamentoToSave
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Intervalos") {
                    ForEach(DoseInterval.allCases) { interval in
                        Button {
                            doseSeleted = interval
                            medicamentoToSave.dosagem = interval.label
                        } label: {
                            HStack {
                                Text(interval.label)
                                    .foregroundStyle(.black)
                                    .font(.callout)
                                Spacer()
                                if doseSeleted.label == interval.label {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                }
                Section {
                    Button {
                        modelContext.insert(medicamentoToSave)
                        manager.navigate(to: .confimation)
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
    }
}

#Preview {
    RecordMedicamentoDosagemView(medicamentoToSave: Medicamento(nome: "", dosagem: "", quantidadeDias: 0, timestamp: Date(), foto: Data()))
        .environmentObject(RecordMedicamentoCoordinatorManager())
}
