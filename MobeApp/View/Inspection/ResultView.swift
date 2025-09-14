//
//  ResultView.swift
//  MobeApp
//
//  Created by Mac on 13/09/25.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var viewModel: CarViewModel
    
    let carReport: Car
    
    
    var body : some View {
        let summary = viewModel.statusSummary(for: carReport)
        let percentage = viewModel.percentageScore(for: carReport)
        let countComponent = viewModel.countComponent(for: carReport)
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Informasi Kendaraan (Kartu Utama)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(alignment: .top) {
                                if let data = carReport.imageData, let uiImg = UIImage(data: data) {
                                    Image(uiImage: uiImg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundStyle(.white)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(carReport.name ?? "")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text(carReport.year ?? "")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Text(carReport.location ?? "")
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
                                    Text("\(carReport.kilometer ?? "-") Km")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 5) {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.secondary)
                                    Text(carReport.createdAt ?? Date(), style: .date)
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
                                        Text("\(summary.critical)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.red)
                                        Text("Kritis")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    VStack {
                                        Text("\(summary.attention)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.orange)
                                        Text("Perhatian")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    VStack {
                                        Text("\(summary.good)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.green)
                                        Text("Aman")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                            }
                            Spacer()
                            
                            Text("\(percentage)%")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(percentage > 70 ? .green : (percentage > 40 ? .orange : .red))
                            
                            
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
                                    Text("\(countComponent)/8")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                                
                                // Detail Item
                                VStack(spacing: 12) {
                                    if let komponenSet = carReport.komponen as? Set<Component> {
                                        ForEach(komponenSet.sorted(by: { $0.name ?? "" < $1.name ?? "" }), id: \.self) { comp in
                                            if let stats = comp.checklist?.stats, stats > 0 {
                                                // mapping angka ke enum langsung di parameter
                                                DetailItemView(
                                                    title: comp.name ?? "Unknown",
                                                    status: {
                                                        switch stats {
                                                        case 5: return .good
                                                        case 3: return .attention
                                                        case 1: return .critical
                                                        default: return .attention
                                                        }
                                                    }(),
                                                    description: comp.checklist?.note
                                                )
                                                Divider()
                                            }
                                        }
                                    }

                                }
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                            }
                            
//                            // Kategori Eksterior
//                            VStack(alignment: .leading, spacing: 8) {
//                                HStack {
//                                    Image(systemName: "car.fill")
//                                        .font(.subheadline)
//                                    Text("Eksterior")
//                                        .font(.subheadline)
//                                        .fontWeight(.bold)
//                                    Spacer()
//                                    Text("10/10")
//                                        .font(.subheadline)
//                                        .fontWeight(.semibold)
//                                }
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 12)
//                                .background(.thinMaterial)
//                                .cornerRadius(10)
//
//                                // Detail Item
//                                VStack(spacing: 12) {
//                                    DetailItemView(title: "Bodi Mobil", status: .good)
//                                    Divider()
//                                    DetailItemView(title: "Kaca Jendela", status: .good)
//                                }
//                                .padding(12)
//                                .background(.ultraThinMaterial)
//                                .cornerRadius(10)
//                            }
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
    let context = PersistenceController.preview.container.viewContext
    let viewModel = CarViewModel(context: context)
    
    // kalau belum ada mobil di preview DB, tambahkan satu
    if viewModel.cars.isEmpty {
        let car = Car(context: context)
        car.carId = UUID()
        car.name = "Mitsubishi Xpander"
        car.year = "2021"
        car.kilometer = "25.000"
        car.location = "Surabaya"
        car.note = "Kondisi sangat bagus"
        car.createdAt = Date()
        try? context.save()
        viewModel.fetchCars()
    }
    
    // ambil mobil pertama untuk preview
    return ResultView(carReport: viewModel.cars.first!)
        .environment(\.managedObjectContext, context)
        .environmentObject(viewModel)
}
