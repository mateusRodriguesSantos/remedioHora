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
    
    @State var notifications: [(identifier: String, title: String, horaData: String)] = []
    
    var body: some View {
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
                        VStack {
                            Text(notification.title)
                            Text(notification.horaData)
                        }
                    }
                }
            }
            
        }
        .onAppear {
            Task {
                DispatchQueue.main.async {
                UNUserNotificationCenter.current()
                    .getDeliveredNotifications { notifications in
                        for notification in notifications {
                            print("ENTREGUE")
                            print("ID:", notification.request.identifier)
                            print("Título:", notification.request.content.title)
                            print("Body:", notification.request.content.body)
                        }
                    }
             
                    UNUserNotificationCenter.current()
                        .getPendingNotificationRequests { notifications in
                            for notification in notifications {
                                print("PENDENTE")
                                print("ID:", notification.identifier)
                                print("Título:", notification.content.title)
                                print("Body:", notification.content.body)
                            }
                        }
                }
                let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
                notifications = requests.map { ($0.identifier, $0.content.title, $0.content.userInfo["horaData"] as? String ?? "") }
            }
        }
    }
}

#Preview {
    ScheduleView()
}
