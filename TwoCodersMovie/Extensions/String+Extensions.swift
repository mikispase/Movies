//
//  String+Extensions.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

public extension String {
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 0..<count ~= length else { return self }
        return self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
    }
}
