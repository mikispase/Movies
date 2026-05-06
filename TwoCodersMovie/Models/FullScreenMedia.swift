//
//  FullScreenMedia.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//


import SwiftUI

class FullScreenMedia : Identifiable, Hashable {
    let url:URL
    
    init(url: URL) {
        self.url = url
    }
    
    static func == (lhs: FullScreenMedia, rhs: FullScreenMedia) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}