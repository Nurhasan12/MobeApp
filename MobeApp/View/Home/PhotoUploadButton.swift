//
//  PhotoUploadButton.swift
//  MobeApp
//
//  Created by Mac on 13/09/25.
//

import SwiftUI

struct PhotoUploadButton: View {
    var hasPhoto: Bool
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(Color(.systemBlue))
            HStack {
                Image(systemName: "arrow.up.doc.fill")
                Text(hasPhoto ? "Ganti Foto" : "Upload Foto")
                    .fontWeight(.semibold)
                Spacer()
                if hasPhoto {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
            .foregroundStyle(.white)
            .padding(12)
        }
        .frame(height: 48)
    }
}
