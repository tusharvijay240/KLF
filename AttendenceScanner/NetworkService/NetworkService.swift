//
//  NetworkService.swift
//  GloRep-SDK
//
//  Created by Apple on 27/11/24.
//

import Alamofire
import Reachability

class NetworkService {
    
    static let shared = NetworkService()
    private let reachability = try? Reachability()
    
    private init() { }
    
    // MARK: - Public Methods
    
    func get<T: Decodable>(url: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        request(url: url, method: .get, parameters: parameters, headers: headers, encoding: URLEncoding.default, completion: completion)
    }
    
    func post<T: Decodable>(url: String, parameters: Parameters?, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        request(url: url, method: .post, parameters: parameters, headers: headers, encoding: JSONEncoding.default, completion: completion)
    }
    
    // MARK: - Private Request Method
    
    private func request<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders?, encoding: ParameterEncoding, completion: @escaping (Result<T, Error>) -> Void) {
        
        // ✅ Check Internet Connection
        guard let reachability = reachability, reachability.connection != .unavailable else {
            completion(.failure(NSError(
                domain: "Network",
                code: NSURLErrorNotConnectedToInternet,
                userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"]
            )))
            return
        }

        // ✅ Set default headers
        var finalHeaders = headers ?? []
        finalHeaders.add(name: "Accept", value: "application/json")
        finalHeaders.add(name: "Content-Type", value: "application/json")

        Logger.log("🔹 Requesting: \(method.rawValue) \(url) with params: \(parameters ?? [:])")

        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: finalHeaders)
            .responseData { response in
                Logger.log("🔸 Response URL: \(String(describing: response.request?.url))")

                switch response.result {
                case .success(let data):
                    // ✅ Pretty-print JSON response
                    if let cleanedData = self.cleanJSONResponse(data) {
                        if let jsonObject = try? JSONSerialization.jsonObject(with: cleanedData, options: .mutableContainers),
                           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                           let prettyPrintedString = String(data: jsonData, encoding: .utf8) {
                            Logger.log("📌 Pretty-Printed JSON Response:\n\(prettyPrintedString)")
                        } else {
                            Logger.log("⚠️ Could not parse JSON data")
                        }
                    }
                    
                    // ✅ Clean JSON Data (Remove <script> tags)
                    if let cleanedData = self.cleanJSONResponse(data) {
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: cleanedData)
                            completion(.success(decodedObject))
                        } catch {
                            Logger.log("❌ Decoding Error: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(NSError(
                            domain: "Network",
                            code: NSURLErrorCannotDecodeContentData,
                            userInfo: [NSLocalizedDescriptionKey: "Invalid JSON Response"]
                        )))
                    }
                    
                case .failure(let error):
                    Logger.log("❌ API Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Helper Method to Clean JSON (Remove <script> Tags)
    
    private func cleanJSONResponse(_ data: Data) -> Data? {
        if let rawString = String(data: data, encoding: .utf8) {
            let cleanedString = rawString.replacingOccurrences(of: "<script[^>]*>[\\s\\S]*?</script>", with: "", options: .regularExpression)
            return cleanedString.data(using: .utf8)
        }
        return nil
    }
}
