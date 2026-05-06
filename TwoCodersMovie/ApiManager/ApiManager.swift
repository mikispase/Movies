//
//  ApiManager.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//
import Foundation
import SwiftyJSON

class ApiManager {
    static let shared = ApiManager()
    
    let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    let env = Bundle.main.object(forInfoDictionaryKey: "APP_ENV") as? String ?? ""

    func request(name: RequestEmitNameEnum, params:[String:Any] = [:], method: HttpMethod = HttpMethod.get) async throws -> JSON {
        debugPrint("########################")
        debugPrint("#### API CALLED with path: \(name.description)")
        debugPrint("#### API CALLED with params:")
        debugPrint((JSON(params)))
        debugPrint("########################")
        
        
        var url:URL?
        
        if method == .get && !params.isEmpty {
            url = buildURL(pathCompoment: name.description, params: params)
        }else {
            let urlString = String(format: "%@/", apiUrl,name.description)
            url = URL(string: urlString)
        }
        
        guard let url = url else { throw NSError(domain: "", code: 1001) }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        if method == .post {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: CustomError.invalidCredentials.localizedDescription, code: 1001)
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                let json = JSON(data)
                return json
            default:
                let errorStr = CustomError.other("error on http path: \(name.description)")
                throw NSError(domain: errorStr.localizedDescription, code: 1001)
            }
            
        }catch {
            throw error
        }
    }
    
    private func buildURL(pathCompoment: String, params: [String: Any]) -> URL? {
        let baseUrl = String(format: "%@/%@", apiUrl,pathCompoment)
        var components = URLComponents(string: baseUrl)
        components?.queryItems = params.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        return components?.url
    }
}

