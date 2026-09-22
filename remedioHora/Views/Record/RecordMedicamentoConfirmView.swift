//
//  RecordMedicamentoConfirmView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 21/09/26.
//

import SwiftUI

struct RecordMedicamentoConfirmView: View {
    
    @EnvironmentObject var manager: RecordMedicamentoCoordinatorManager
    @State private var degrees: Double = 0.0
    @State private var scale: Double = 1.0
    @State private var toggleScale: Bool = false
 
    var body: some View {
        VStack {
            Text("Medicamento salvo!")
                .font(.title)
                .padding(.top, 48)
                Spacer()
            ZStack {
                Image(systemName: "seal.fill")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .foregroundStyle(Color.green)
                    .rotationEffect(Angle(degrees: degrees))
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 110, height: 110)
                    .foregroundStyle(Color.white)
                    .scaleEffect(toggleScale ? 1.3 : 1.0)
            }
            Spacer()
            Button {
                manager.dismiss()
            } label: {
                Text("Tela Inicial")
                    .padding(20)
                    .foregroundStyle(Color.black)
                    .background {
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .fill(Color.yellow)
                    }
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(0.01), repeats: true, block: { timer in
                degrees += 0.50
                scale += 0.6
            })
            var countScale = 0
            Timer.scheduledTimer(withTimeInterval: TimeInterval(0.12), repeats: true, block: { timer in
                withAnimation {
                    toggleScale.toggle()
                }
                countScale += 1
                if countScale == 3 {
                    timer.invalidate()
                }
            })
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RecordMedicamentoConfirmView()
}
