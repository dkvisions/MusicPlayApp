//
//  AppRequestManager.swift
//  iWatchApp Watch App
//
//  Created by Rahul Vishwakarma on 18/01/24.
//

import Foundation


class AppRequestManager: AppRequestHelper {
    
    static let shared = AppRequestManager()

    override init() {
        super.init()
    }
    
    func fetchDataServicePost<Model: Decodable>(_ myModel: Model.Type, _ serviceName: RequestUrls,_ params: [String: Any] = [String: Any](), httpMethod: HTTPMethod = .post) async throws -> Model {
        
        do {
            let data = try await self.fetchRequest(params, serviceName.rawValue, httpMethod: httpMethod)
            do {
                let decodedData = try JSONDecoder().decode(myModel, from: data)
                return decodedData
                
            } catch {
                throw ResponseError.decodeError
            }
        } catch {
            throw error
        }
    }
    
    func fetchMediaFile(urlString: String) async throws -> String {
        
        let urlStringAdd = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: urlStringAdd ?? "") else { throw ResponseError.invalidURL}
        
        do {
            let mediaPath = try await self.downloadMedia(url: url)
            return mediaPath
            
        } catch {
            throw error
        }
        
    }
}
