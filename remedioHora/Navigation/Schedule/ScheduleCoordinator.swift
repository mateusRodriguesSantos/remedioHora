//
//  ScheduleCoordinator.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import SwiftData

enum StepsSchedule: Hashable {
    case today
}

struct ScheduleCoordinator: View {

    @StateObject var manager: ScheduleCoordinatorManager = ScheduleCoordinatorManager()
    
    var body: some View {
        NavigationStack(path: $manager.path) {
            ScheduleView()
                .navigationDestination(for: StepsSchedule.self) { destination in
                    switch destination {
                    case .today:
                        ScheduleView()
                    }
                }
        }
        .environmentObject(manager)
    }
}

#Preview {
    ScheduleCoordinator()
}
