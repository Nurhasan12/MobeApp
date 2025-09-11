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

struct HomeView: View {
    @State private var showInfo = false
    @State private var showNew = false

    var body: some View {
        NavigationStack {
            // --- Konten utama bisa discroll
            ScrollView {
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
                    }
                }
            }
            // Tambah "ruang kosong" setinggi FAB + margin supaya konten terdorong ke atas
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 100) // sesuaikan jika ukuran FAB diubah
            }
//            // FAB mengambang di tengah bawah
//            .overlay(alignment: .bottom) {
//                Button {
//                    showNew = true
//                } label: {
//                    Image(systemName: "plus")
//                        .font(.system(size: 28, weight: .bold))
//                        .frame(width: 64, height: 64)                   // 64–72pt ideal (>=44pt HIG)
//                        .foregroundColor(.white)
//                        .background(Circle().fill(Color.blue))
//                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
//                        .accessibilityLabel("Tambah inspeksi baru")
//                }
//                .padding(.bottom, 24) // jarak dari home indicator
//            }
            .navigationTitle("Inspeksi")
            .toolbar {
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
                AddInspectView()
            }
        }
    }
}


#Preview {
    HomeView()
}
