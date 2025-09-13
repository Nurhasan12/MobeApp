//
//  CarRow.swift
//  MobeApp
//
//  Created by Mac on 12/09/25.
//


import SwiftUI

struct CarRow: View {
    let car: Car
    
    var body: some View {
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
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
