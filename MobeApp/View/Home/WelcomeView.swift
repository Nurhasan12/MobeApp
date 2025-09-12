//
//  WelcomeView.swift
//  MobeApp
//
//  Created by Mac on 12/09/25.
//


import SwiftUI

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

#Preview {
    WelcomeView()
}
