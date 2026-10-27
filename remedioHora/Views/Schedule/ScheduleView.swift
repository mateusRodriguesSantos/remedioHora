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
   
    @StateObject var viewModel: ScheduleViewModel = ScheduleViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Programação")
                    .font(.title)
                
                if viewModel.notifications.isEmpty {
                    Text("Sem medicamentos cadastrados!")
                        .font(.caption2)
                        .padding(.top, 120)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.notifications, id: \.identifier) { notification in
                            Button {
                                viewModel.showAlertConfirmation = true
                                viewModel.medicineNameToUpdate = notification.title
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(notification.title)
                                    Text("\(viewModel.getInterval(nomeMedicine: notification.title))")
                                    if viewModel.isNeedConfirmation(nomeMedicine: notification.title) {
                                        Text("Atrasado")
                                            .padding(8)
                                            .foregroundStyle(Color.white)
                                            .background {
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(.red)
                                            }
                                    }
                                }
                            }
                            .foregroundStyle(.black)
                            .allowsHitTesting(!viewModel.isNeedConfirmation(nomeMedicine: notification.title))
                        }
                    }
                }
            }
            if viewModel.showLoading {
                ProgressView()
            }
        }
        .alert("", isPresented: $viewModel.showAlertConfirmation, actions: {
            Button {
                viewModel.updateMedicineDoses()
            } label: {
                Text("Tomei na hora")
            }
            Button {
                sharedInfo.resetScheduleView = true
            } label: {
                Text("Atrasou")
            }
        }, message: {
            Text("Confirme se tomou ou atrasou o medicamento.")
        })
        .task {
            await viewModel.notificationCountability()
        }
        .onChange(of: sharedInfo.resetScheduleView) {
            Task {
                if sharedInfo.resetScheduleView {
                    await viewModel.notificationCountability()
                    sharedInfo.resetScheduleView = false
                }
            }
        }
    }
    
   
}

#Preview {
    ScheduleView()
}
