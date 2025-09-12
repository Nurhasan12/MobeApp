//
//  CheckList.swift
//  Mobee
//
//  Created by Mac on 08/09/25.
//

import SwiftUI

struct CheckList: View {
    let item: InspectionItem
    @State private var isExpanded = false
    @State private var selectedStatus = -1
    @State private var notes: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(item.title)
                    .bold()
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .bold()
            }
            .padding(.vertical, 20)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation { isExpanded.toggle() }
            }
            .padding(.horizontal)
            .padding(.vertical,4)
            
            if isExpanded {
                expanded(item: item, selectedStatus: $selectedStatus, notes: $notes)
            }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
}


func expanded(item: InspectionItem, selectedStatus: Binding<Int>, notes: Binding<String>) -> some View {
    VStack  {
        Image(item.imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(4)
            .padding(.horizontal, 24)
        HStack (alignment: .top) {
            Image (systemName: "info.circle")
            Text(item.instruction)
        }
        
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        
        HStack (spacing: 30) {
            statusButton(label: "Bersih", image: "hand.thumbsup.fill", color: .green, clickColor: .greenCustom, option: 0, selectedStatus: selectedStatus, degree: 0)
            statusButton(label: "Noda", image: "hand.thumbsup.fill", color: .yellow, clickColor: .yellowCustom, option: 1, selectedStatus: selectedStatus, degree: 270)
            statusButton(label: "Sobek", image: "hand.thumbsdown.fill", color: .red, clickColor: .redCustom, option: 2, selectedStatus: selectedStatus, degree: 0)
        }
        TextField("Tambahkan Catatan", text: notes, axis: .vertical)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(16)
        
    }
    
}

func statusButton(
    label: String,
    image: String,
    color: Color,
    clickColor: Color,
    option: Int,
    selectedStatus: Binding<Int>,
    degree: Double
) -> some View {
    VStack(spacing: 16) {
        Image(systemName: image)
            .resizable()
            .scaledToFit()
            .foregroundStyle(color)
            .rotationEffect(.degrees(degree))
            .frame(height: 36)
            .padding(.horizontal, 20)
            .padding(.top, 8)
        
        Text(label)
            .padding(.bottom, 8)
    }
    .background(selectedStatus.wrappedValue == option ? clickColor : .white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    
    .onTapGesture {
        selectedStatus.wrappedValue = option
    }
}




