//
//  ResultView.swift
//  MobeApp
//
//  Created by Mac on 13/09/25.
//

import SwiftUI

struct ResultView: View {
    
    var body : some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Informasi Kendaraan (Kartu Utama)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(alignment: .top) {
                                
                                    Image(systemName: "car.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundStyle(.white)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                
                                
                                VStack(alignment: .leading) {
                                    Text("NAMA SAYA")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("2026")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Text("LOKASI")
                                        .font(.caption)
                                }
                                .padding(.leading, 10)
                                
                                Spacer()
                            }
                            
                            Divider() // Pembatas untuk visual yang lebih rapi
                            
                            HStack {
                                HStack(spacing: 5) {
                                    Image(systemName: "gauge.with.dots.needle.67percent")
                                        .foregroundStyle(.secondary)
                                    Text(" 2026 KM")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 5) {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.secondary)
                                    Text("03 September 2025")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(16) // Sudut yang lebih tumpul
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                        
                        // Skor Keseluruhan
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Skor Keseluruhan")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                
                                Text("Kondisi umum kendaraan saat inspeksi.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                HStack(spacing: 20) {
                                    VStack {
                                        Text("1")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.red)
                                        Text("Kritis")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    VStack {
                                        Text("2")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.orange)
                                        Text("Perhatian")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                            }
                            Spacer()
                            
                            Text("100%")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                            
                            
                        }
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                        .padding(.horizontal)
                        
                        // --- Rincian Inspeksi
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Rincian Inspeksi")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                            
                            // Kategori Interior
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "eye.fill")
                                        .font(.subheadline)
                                    Text("Interior")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("8/10")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                                
                                // Detail Item
                                VStack(spacing: 12) {
                                    DetailItemView(title: "Jok Mobil", status: .critical, description: "Ini eror")
                                    Divider()
                                    DetailItemView(title: "Karpet", status: .good)
                                    Divider()
                                    DetailItemView(title: "Dashboard", status: .good)
                                }
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                            }
                            
                            // Kategori Eksterior
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "car.fill")
                                        .font(.subheadline)
                                    Text("Eksterior")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("10/10")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                                
                                // Detail Item
                                VStack(spacing: 12) {
                                    DetailItemView(title: "Bodi Mobil", status: .good)
                                    Divider()
                                    DetailItemView(title: "Kaca Jendela", status: .good)
                                }
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                .navigationTitle("Laporan Hasil Inspeksi")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

// --- Komponen
enum InspectionStatus {
    case good, critical, attention
}

struct DetailItemView: View {
    var title: String
    var status: InspectionStatus
    var description: String? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                if let desc = description {
                    Text(desc)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: status == .good ? "checkmark.circle.fill" : (status == .attention ? "exclamationmark.triangle.fill" : "xmark.circle.fill"))
                    .font(.caption)
                    .foregroundStyle(.white)
                Text(statusText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(statusColor)
            .cornerRadius(20)
        }
    }
    
    var statusText: String {
        switch status {
        case .good: return "Baik"
        case .critical: return "Rusak"
        case .attention: return "Perhatian"
        }
    }
    
    var statusColor: Color {
        switch status {
        case .good: return .green
        case .critical: return .red
        case .attention: return .orange
        }
    }
}

#Preview {
    ResultView()
}
