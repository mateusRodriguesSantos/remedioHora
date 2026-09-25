//
//  remedioHoraApp.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 16/09/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@MainActor
var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Medicamento.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@main
struct remedioHoraApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private let notificationDelegate = NotificationDelegate()
  
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    enum Errors: Error {
        case fetchUnsuccessful
        case medicamentoNotFound
        case intervalNotFound
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let title = notification.request.content.title
        let descriptor = FetchDescriptor<Medicamento>(
            predicate: #Predicate { $0.nome == title },
            sortBy: [
                .init(\.id)
            ]
        )
        
        do {
            let result = try sharedModelContainer.mainContext.fetch(descriptor)
            if result.count == 1 {
                if let medicamento = result.first {
                    if let enumInterval = DoseInterval.verify(dose: medicamento.intervalo) {
                        if let nextDate = medicamento.nextDate {
                            
                            let calendar = Calendar(identifier: .gregorian)
                            let newDate = calendar.date(byAdding: enumInterval.components, to: nextDate)
                            let newDateComp = calendar.dateComponents(in: .current, from: newDate ?? Date())
                            medicamento.nextDate = newDateComp.date
                            createNotification(nameMedicine: medicamento.nome, dateComponents: newDateComp)
                            
                            try sharedModelContainer.mainContext.save()
                            
                        } else {
                            
                            let calendar = Calendar(identifier: .gregorian)
                            let newDate = calendar.date(byAdding: enumInterval.components, to: medicamento.timestamp)
                            let newDateComp = calendar.dateComponents(in: .current, from: newDate ?? Date())
                            medicamento.nextDate = newDateComp.date
                            createNotification(nameMedicine: medicamento.nome, dateComponents: newDateComp)
                            
                            try sharedModelContainer.mainContext.save()
                        }
                    } else {
                        throw Errors.intervalNotFound
                    }
                } else {
                    throw Errors.medicamentoNotFound
                }
            } else {
                throw Errors.fetchUnsuccessful
            }
        } catch {
            dump(error)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let title = response.notification.request.content.title
        let descriptor = FetchDescriptor<Medicamento>(
            predicate: #Predicate { $0.nome == title },
            sortBy: [
                .init(\.id)
            ]
        )
        
        do {
            let result = try sharedModelContainer.mainContext.fetch(descriptor)
            if result.count == 1 {
                if let medicamento = result.first {
                    if let enumInterval = DoseInterval.verify(dose: medicamento.intervalo) {
                        if let nextDate = medicamento.nextDate {
                            
                            let calendar = Calendar(identifier: .gregorian)
                            let newDate = calendar.date(byAdding: enumInterval.components, to: nextDate)
                            let newDateComp = calendar.dateComponents(in: .current, from: newDate ?? Date())
                            medicamento.nextDate = newDateComp.date
                            createNotification(nameMedicine: medicamento.nome, dateComponents: newDateComp)
                            
                            try sharedModelContainer.mainContext.save()
                            
                        } else {
                            
                            let calendar = Calendar(identifier: .gregorian)
                            let newDate = calendar.date(byAdding: enumInterval.components, to: medicamento.timestamp)
                            let newDateComp = calendar.dateComponents(in: .current, from: newDate ?? Date())
                            medicamento.nextDate = newDateComp.date
                            createNotification(nameMedicine: medicamento.nome, dateComponents: newDateComp)
                            
                            try sharedModelContainer.mainContext.save()
                        }
                    }else {
                        throw Errors.intervalNotFound
                    }
                } else {
                    throw Errors.medicamentoNotFound
                }
            } else {
                throw Errors.fetchUnsuccessful
            }
        } catch {
            dump(error)
        }
        
        completionHandler()
    }
    
    private func createNotification(nameMedicine: String, dateComponents: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: nameMedicine, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hora de tomar seu remédio!!!", arguments: nil)
        
        content.sound = UNNotificationSound.defaultCritical
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        content.userInfo = ["horaData":"\(dateComponents.day ?? 0)/\(dateComponents.month ?? 0)/\(dateComponents.year ?? 0) - \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)"]
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
