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
                        saveNotification(nameMedicine: medicamentoToSave.nome, dose: medicamentoToSave.dosagem, date: medicamentoToSave.timestamp)
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
    
    private func saveNotification(nameMedicine: String, dose: String, date: Date) {
        let contentNotification = UNMutableNotificationContent()
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: nameMedicine, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hora de tomar seu remédio, lembre-se: \(dose)_", arguments: nil)
        content.sound = UNNotificationSound.defaultCritical
        
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents(in: .current, from: date)
        guard var day = dateComponents.day else { return }
        
        if let doseEnum = DoseInterval.verify(dose: dose) {
            if let newDate = calendar.date(byAdding: doseEnum.components, to: date) {
                let newDateComponents = calendar.dateComponents(in: .current, from: newDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: newDateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if error == nil {
                        print("Notification saved!!!")
                    } else {
                        dump(error.unsafelyUnwrapped)
                    }
                }
            }
        }
    }
}

#Preview {
    RecordMedicamentoDosagemView(medicamentoToSave: Medicamento(nome: "", dosagem: "", quantidadeDias: 0, timestamp: Date(), foto: Data()))
        .environmentObject(RecordMedicamentoCoordinatorManager())
}
