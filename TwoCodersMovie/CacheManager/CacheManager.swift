//
//  CacheManager.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 09/05/2026.
//
import Foundation

class CacheManager {
    static let shared = CacheManager()
       
    func getDocumentsDirectory() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            print("Error: Could not find the user's documents directory.")
            return URL(fileURLWithPath: NSTemporaryDirectory())
        }
    }
    
    @discardableResult
    func set<T: Codable>(_ value: T, forKey key: String) -> Bool {
        let fileURL = getDocumentsDirectory().appendingPathComponent(key)

        do {
            let data = try PropertyListEncoder().encode(value)
            try data.write(to: fileURL)
            print("List saved to: \(fileURL.path)")
            return true
        } catch {
            print("Failed to save list: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        
        let fileURL = getDocumentsDirectory().appendingPathComponent(key)
        do {
            let data = try Data(contentsOf: fileURL)
            let object = try PropertyListDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Failed to load: \(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func remove(forKey key: String) -> Bool {
        let fileURL = getDocumentsDirectory().appendingPathComponent(key)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted: \(fileURL.path)")
                return true
            } catch {
                print("Failed to delete: \(error.localizedDescription)")
                return false
            }
        } else {
            print("File not found: \(fileURL.path)")
            return true
        }
    }
}
