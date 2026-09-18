//
//  RecordMedicamentoDosagemView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI

struct RecordMedicamentoDosagemView: View {
    
    @EnvironmentObject var manager: RecordMedicamentoCoordinatorManager
    
    var body: some View {
        VStack {
            Form {
                Section("Intervalos") {
                    ForEach(DoseInterval.allCases) { interval in
                        Button {
                   
                        } label: {
                            Text(interval.label)
                                .foregroundStyle(.black)
                                .font(.callout)
                        }
                    }
                }
                Section {
                    Button {
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
}

#Preview {
    RecordMedicamentoDosagemView()
        .environmentObject(RecordMedicamentoCoordinatorManager())
}
