//
//  Home.swift
//  MobeApp
//
//  Created by Mac on 11/09/25.
//

//
//  ContentView.swift
//  MobeApps1
//
//  Created by Mac on 06/09/25.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var viewModel: CarViewModel
    @State private var showAddModal = false
    @State private var showInfoModal = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.cars.isEmpty {
                    VStack{
                        Spacer()
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text("Tambah Untuk Mulai")
                            .bold()
                            .padding(.top, 8)
                        
                        Text("Selesaikan inspeksi untuk mendapatkan persentase kelayakan mobil bekas")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    }
                } else {
                    // Tampilan ListCar
                    ListCar()
                }
            }
            .navigationTitle("Inspeksi")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button { showAddModal = true } label: {
                        Image(systemName: "plus")
                    }
                    Button { showInfoModal = true } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddModal) {
                AddCar()
            }
            .sheet(isPresented: $showInfoModal) {
                InspectInfoView()
            }
        }
    }
}

#Preview {
    Home()
        .environmentObject(CarViewModel(context: PersistenceController.shared.container.viewContext))
}
