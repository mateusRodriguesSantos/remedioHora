//
//  ScheduleView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import UserNotifications

@MainActor
struct ScheduleView: View {
    
    @EnvironmentObject var sharedInfo: SharedInformation
    @State var notifications: [(identifier: String, title: String, previsao: String)] = []
    @State var showLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Programação")
                    .font(.title)
                
                if notifications.isEmpty {
                    Text("Sem medicamentos cadastrados!")
                        .font(.caption2)
                        .padding(.top, 120)
                    Spacer()
                } else {
                    List {
                        ForEach(notifications, id: \.identifier) { notification in
                            VStack(alignment: .leading) {
                                Text(notification.title)
                                Text("Previsão: \(notification.previsao)")
                            }
                        }
                    }
                }
            }
            if showLoading {
                ProgressView()
            }
        }
        .task {
            await notificationCountability()
        }
        .onChange(of: sharedInfo.resetScheduleView) {
            Task {
                if sharedInfo.resetScheduleView {
                    await notificationCountability()
                    sharedInfo.resetScheduleView = false
                }
            }
        }
    }
    
    private func notificationCountability() async {
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

#Preview {
    ScheduleView()
}
