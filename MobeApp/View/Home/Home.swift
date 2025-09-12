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
    
    @State private var showInfo = false
    @State private var showNew = false
    
    
    var body: some View {
        NavigationStack {
            // --- Konten utama bisa discroll
            if viewModel.cars.isEmpty{
                ScrollView(.vertical, showsIndicators: true) {
                    WelcomeView()
                }
            }else{
                List {
                    ForEach(viewModel.cars) { car in
                        CarRow(car: car)
                    }
                }
                .navigationTitle("Inspeksi")
                .toolbar(){
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showNew = true
                        } label: { Image(systemName: "plus") }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showInfo = true
                        } label: { Image(systemName: "info.circle") }
                    }
                }
                .sheet(isPresented: $showInfo) { InspectInfoView()
                    .presentationDetents([.large]) }
                .sheet(isPresented: $showNew) {
                    AddCar()
                }
            }
        }
    }
}



#Preview {
    Home()
}



