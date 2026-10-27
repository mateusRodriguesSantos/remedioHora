//
//  ScheduleViewModel.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 21/10/26.
//

import SwiftUI
import Combine
import SwiftData

class ScheduleViewModel: ObservableObject {
    
    @Published var notifications: [(identifier: String, title: String, previsao: String)] = []
    @Published var showLoading: Bool = false
    let dateFormatter: DateFormatter = DateFormatter()
    @Published var showAlertConfirmation: Bool = false
    @Published var medicineNameToUpdate: String = ""

    
    func updateMedicineDoses() {
        do {
            let medicamentos =  try sharedModelContainer.mainContext.fetch(FetchDescriptor<Medicamento>(predicate: #Predicate { medicamento in
                return medicamento.nome == medicineNameToUpdate
            }))
            if let find = medicamentos.first {
                if let nextDates = find.nextDates {
                    let doseEnum = DoseInterval.verify(dose: find.intervalo) ?? .every15Minutes
                    let lastDate = nextDates.last ?? Date()
                    let calendar = Calendar(identifier: .gregorian)
                    let newDate = calendar.date(byAdding: doseEnum.components, to: lastDate) ?? Date()
                    find.nextDates?.append(newDate)
                    find.qtdDoses -= 1
                }
            }
        } catch {
          dump(error)
        }
    }
    
    func isNeedConfirmation(nomeMedicine: String) -> Bool {
        do {
            let medicamentos =  try sharedModelContainer.mainContext.fetch(FetchDescriptor<Medicamento>(predicate: #Predicate { medicamento in
                return medicamento.nome == nomeMedicine
            }))
            if let find = medicamentos.first {
                return (find.nextDates?.last ?? Date()) <= Date()
            } else {
                return false
            }
        } catch {
          dump(error)
        }
        return false
    }
    
    func getInterval(nomeMedicine: String) -> String {
        do {
            let medicamentos =  try sharedModelContainer.mainContext.fetch(FetchDescriptor<Medicamento>(predicate: #Predicate { medicamento in
                return medicamento.nome == nomeMedicine
            }))
            if let find = medicamentos.first {
                return find.intervalo
            } else {
                return ""
            }
        } catch {
          dump(error)
        }
        return ""
    }
    
    func getNextDateTrigger(nomeMedicine: String) -> String {
        do {
            let medicamentos =  try sharedModelContainer.mainContext.fetch(FetchDescriptor<Medicamento>(predicate: #Predicate { medicamento in
                return medicamento.nome == nomeMedicine
            }))
            if let find = medicamentos.first {
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                return dateFormatter.string(from: find.nextDates?.last ?? Date())
            } else {
                return ""
            }
        } catch {
          dump(error)
        }
        return ""
    }
    
    func notificationCountability() async {
        await MainActor.run {
            showLoading = true
        }

        defer {
            Task { @MainActor in
                showLoading = false
            }
        }

        let center = UNUserNotificationCenter.current()

        let delivered = await center.deliveredNotifications()

        for notification in delivered {
            print("ENTREGUE")
            print("ID:", notification.request.identifier)
            print("Título:", notification.request.content.title)
            print("Body:", notification.request.content.body)
            print("Trigger:", notification.request.trigger.debugDescription)
        }

        let requests = await center.pendingNotificationRequests()

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        formatter.timeZone = .current

        var result: [(String, String, previsao: String)] = []

        for request in requests {
            guard let trigger = request.trigger
                    as? UNTimeIntervalNotificationTrigger else {
                continue
            }

            print("ID:", request.identifier)
            print("Intervalo:", trigger.timeInterval)
            print("Marcacao:", request.content.userInfo["Horario da marcacao"] ?? "")

            if let data = trigger.nextTriggerDate() {
                //let dateString = formatter.string(from: data)
                
                print("Previsao \(formatter.string(from: data))")
                let calendar = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date(), to: data)
          
                result.append((
                    request.identifier,
                    request.content.title,
                    previsao: "\(trigger.nextTriggerDate())"
                ))
            }
        }

        await MainActor.run {
            notifications = result
        }

        // Mantém o loading visível por pelo menos 1 segundo.
        try? await Task.sleep(for: .seconds(1))

        await MainActor.run {
            showLoading = false
        }
    }
    
}
