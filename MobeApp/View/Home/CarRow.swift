//
//  CarRow.swift
//  MobeApp
//
//  Created by Mac on 12/09/25.
//


import SwiftUI

struct CarRow: View {
    @ObservedObject var car: Car
    @EnvironmentObject var viewModel: CarViewModel
    
    var body: some View {
        let percentage = viewModel.percentageScore(for: car)
        HStack(spacing: 12) {
            if let data = car.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "car.fill")
                            .foregroundStyle(.secondary)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(car.name ?? "")
                    .font(.subheadline).bold()
                Text("Tahun \(car.year ?? "-") • \(car.kilometer ?? "-") km")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Label(car.location ?? "Lokasi tidak diketahui", systemImage: "mappin.and.ellipse")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                if let createdAt = car.createdAt {
                    Text(formattedDate(createdAt))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            VStack{
                Text("Kondisi")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text("\(percentage)%")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(percentage > 70 ? .green : (percentage > 40 ? .orange : .red))
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "id_ID") // Optional: Bahasa Indonesia
        return formatter.string(from: date)
    }
