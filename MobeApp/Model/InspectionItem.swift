//
//  Inspection.swift
//  Mobee
//
//  Created by Mac on 09/09/25.
//

import Foundation

struct InspectionItem : Identifiable {
    let id = UUID()
    var title: String
    var imageName: String
    let instruction: String
    var status: Int = 0
    var note: String = ""
}

