//
//  InspectionInfoView.swift
//  MobeApp
//
//  Created by Mac on 11/09/25.
//

import SwiftUI

struct InspectInfoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // Header: ikon + judul + subjudul
                    VStack(spacing: 8) {
                        // ganti "logo" dengan asetmu, atau pakai SF Symbol:
                        Image("logo") // fallback:
                            .resizable()
                            .scaledToFit()
                            .frame(width: 84, height: 84)
                            .foregroundColor(.blue)
                            .accessibilityHidden(true)

                        Text("Cara Kerja Inspeksi")
                            .font(.title3).bold()
                            .multilineTextAlignment(.center)

                        Text("Ikuti langkah-langkah mudah ini untuk melakukan inspeksi mobil")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)

                    // Daftar langkah
                    VStack(spacing: 12) {
                        StepRow(index: 1,
                                title: "Tambah Inspeksi Baru",
                                subtitle: "Tekan tombol + dibawah untuk memulai inspeksi")
                        StepRow(index: 2,
                                title: "Isikan Info Mobil",
                                subtitle: "Masukkan detail mobil seperti merk, model, tahun, dan informasi lainnya")
                        StepRow(index: 3,
                                title: "Inspeksi Berhasil Ditambahkan",
                                subtitle: "Data mobil tersimpan dan siap untuk proses inspeksi")
                        StepRow(index: 4,
                                title: "Lakukan Inspeksi",
                                subtitle: "Periksa kondisi mobil sesuai dengan kategori yang sudah disediakan")
                        StepRow(index: 5,
                                title: "Lihat report",
                                subtitle: "Dapatkan laporan lengkap dengan persentase kelayakan mobil")
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Tutup") { dismiss() }
                }
            }
        }
    }
}



#Preview {
    InspectInfoView()
}
