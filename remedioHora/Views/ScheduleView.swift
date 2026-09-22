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
    
    @State var notifications: [(identifier: String, title: String)] = []
    
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
                        Text(notification.title)
                    }
                }
            }
            
        }
        .onAppear {
            Task {
                let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
                notifications = requests.map { ($0.identifier, $0.content.title) }
            }
        }
    }
}

#Preview {
    ScheduleView()
}
