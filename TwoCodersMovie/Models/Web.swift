//
//  Web.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//


import SwiftUI

class Web: Identifiable, Hashable {
    let url:URL
    
    init(url: URL) {
        self.url = url
    }
    
    static func == (lhs: Web, rhs: Web) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}