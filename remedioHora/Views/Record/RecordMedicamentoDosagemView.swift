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
            let calendar = Calendar(identifier: .gregorian)
            let initialDateComp = calendar.dateComponents(in: .current, from: date)
  
            switch date.compare(Date()) {
            case .orderedAscending, .orderedSame:
                let newDate = calendar.date(byAdding: doseEnum.components, to: date)
                let newDateComp = calendar.dateComponents(in: .current, from: newDate ?? Date())
                medicamentoToSave.nextDate = newDateComp.date
                createNotification(nameMedicine: nameMedicine, dateComponents: newDateComp)
            case .orderedDescending:
                createNotification(nameMedicine: nameMedicine, dateComponents: initialDateComp)
            }
            
            modelContext.insert(medicamentoToSave)
            manager.navigate(to: .confimation)
        } else {
           showAlert = true
        }
    }
    
    private func createNotification(nameMedicine: String, dateComponents: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: nameMedicine, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hora de tomar seu remédio!!!", arguments: nil)
        
        content.sound = UNNotificationSound.defaultCritical
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        content.userInfo = ["horaData":"\(dateComponents.day ?? 0)/\(dateComponents.month ?? 0)/\(dateComponents.year ?? 0) - \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)"]
        //content.userInfo = ["horaData":"\(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)"]
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

#Preview {
    RecordMedicamentoDosagemView(medicamentoToSave: Medicamento(nome: "", dosagem: "", quantidadeDias: 0, timestamp: Date(), foto: Data(), intervalo: ""))
        .environmentObject(RecordMedicamentoCoordinatorManager())
}
