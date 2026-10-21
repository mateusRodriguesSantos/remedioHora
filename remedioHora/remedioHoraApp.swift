//
//  remedioHoraApp.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 16/09/26.
//

import SwiftUI
import SwiftData
import UserNotifications
import Combine

class SharedInformation: ObservableObject {
    
    static let shared: SharedInformation = SharedInformation()
    
    @Published var resetScheduleView: Bool = false
}

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
        .environmentObject(SharedInformation.shared)
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
        SharedInformation.shared.resetScheduleView = true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        SharedInformation.shared.resetScheduleView = true
        completionHandler()
    }
    
    public static func createNotification(nameMedicine: String, dateComponents: DateComponents? = nil, withTimeInvertal: TimeInterval? = nil) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: nameMedicine, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hora de tomar seu remédio! Abra o aplicativo para confirmar a dose.", arguments: nil)
        
        content.sound = UNNotificationSound.default
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        content.userInfo = ["Horario da marcacao": "\(dateFormatter.string(from: Date()))"]
        
        if let timeInterval = withTimeInvertal {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
            NotificationDelegate.registerNotification(content: content, trigger: trigger)
        }
        if let components = dateComponents {
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            NotificationDelegate.registerNotification(content: content, trigger: trigger)
        }
    }
    
    private static func registerNotification(content: UNNotificationContent, trigger: UNNotificationTrigger) {
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
