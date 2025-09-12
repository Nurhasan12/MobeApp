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


struct WelcomeView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack {
                Image("logo") // ambil dari Assets
                    .resizable() //Membuat image bisa diubah ukurannya oleh mo(difier berikutnya.
                    .scaledToFit() //Menjaga rasio aspek gambar saat diskalakan (tidak gepeng).
                    .frame(width: 100, height: 100) //Memberi ukuran tampilan 136 x 136 pt untuk image.
                    .scaleEffect(1) //nanti gambarnya gede dr ukuran 0,6
                    .opacity(1)
                    .padding(.top, 150)
                Text("Mulai Inspeksi Baru")
                    .font(.system(size: 20, weight: .bold))
                Text("Buat Inspeksi Mobil")
                Text("Klik Tombol Tambah untuk Mulai")
                //                NavigationLink (destination: ListCar(), label: { Text("Daftar Mobil")
                //                } ) .padding(40)
            }
            
        }
    }
}

struct CarRow: View {
    let car: Car
    // @EnvironmentObject var viewModel: CarViewModel  // ga perlu kalau row cuma render UI
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 56, height: 56)
                .overlay(Image(systemName: "car.fill").foregroundStyle(.secondary))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(car.name ?? "")
                    .font(.subheadline).bold()
                Text("Tahun \(car.year ?? "-") • \(car.kilometer ?? "-") km")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Label(car.location ?? "Lokasi tidak diketahui", systemImage: "mappin.and.ellipse")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle()) // biar seluruh row bisa di-tap
    }
}


struct ListCar: View {
    @EnvironmentObject var viewModel: CarViewModel
    @State private var selectedCar: Car? = nil
    
    var body: some View {
        List {
            ForEach(viewModel.cars) { car in
                CarRow(car: car)
                    .onTapGesture { selectedCar = car }
                    
            }
            .onDelete(perform: viewModel.deleteItems)
        }
        .sheet(item: $selectedCar, onDismiss: didDismiss) { car in
            // Kalau ShowInspection butuh car, lebih enak begini:
            //            ShowInspection(car: car)
        }
    }
    
    private func didDismiss() {
        guard let car = selectedCar else { return }
        viewModel.addComponentsIfNotExist(to: car, items: viewModel.itemsInspection)
        // Reset pilihan jika mau:
        selectedCar = nil
    }
}
