//
//  APIService.swift
//  AM-AI_Front
//
//  Created by Matthew McLellan on 11/12/25.
//

import UIKit
internal import Foundation

class APIService {
    static let shared = APIService()
    
    let baseURL = "https://amsolutions-seattle.com/api/chat"
    
    private init() {}
    
    // login function
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let success = json["success"] as? Bool,
               success {
                completion(true, nil)
            } else {
                completion(false, "Invalid credentials")
            }
        }.resume()
    }
    
    // diagnose function
    func diagnose(image: UIImage, completion: @escaping (APIService.DiagnosisResult?) -> Void) {
        guard let url = URL(string: "\(baseURL)/diagnose") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try? decoder.decode(APIService.DiagnosisResult.self, from: data)
                completion(result)
            }
        }.resume()
    }
}

extension APIService {
    // domain results
    struct DiagnosisResult: Codable {
        let success: Bool
        let uploadId: Int
        let diagnosis: Diagnosis
        let severity: Severity
        let instructions: String
        let products: [Product]
        let arAvailable: Bool
    }

    struct Diagnosis: Codable {
        let final: String
    }

    struct Severity: Codable {
        let level: String
        let canDrive: Bool
        let maxDistance: String
        let estimatedCost: String
        let timeToRepair: String
        let color: String
    }

    struct Product: Codable {
        let title: String
        let image: String
        let price: String
        let rating: Double
        let url: String
    }
}
