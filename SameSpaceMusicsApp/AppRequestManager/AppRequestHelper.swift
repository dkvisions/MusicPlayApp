//
//  Services.swift
//  iWatchApp Watch App
//
//  Created by Rahul Vishwakarma on 18/01/24.
//

import Foundation

enum ResponseStatus {
    case loading
    case success
    case failed
}

enum  ResponseError: Error {

    case documnentDirectoryNil
    case invalidData
    case decodeError
    case error(Int)
    case somthingWentWrong
    case jsonObjectError
    case invalidURL

}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

class AppRequestHelper: NSObject {
    
    var session: URLSession!
    
    var documentDirectoryForSong: URL?

    override init() {
        
        super.init()
        self.session = URLSession(configuration: .default)
        
        
        do {
            documentDirectoryForSong = try createFolderInDocumentsDirectoryIfNeeded()
        } catch {
            print(error.localizedDescription)
        }
            
    }
    
    
    func fetchRequest(_ params: [String: Any],_ serviceName: String, httpMethod: HTTPMethod = .post) async throws -> Data {
        
        var request = URLRequest(url: URL(string: "\(RequestUrls.baseUrl)\(serviceName)")!, timeoutInterval: 20.0)

        print(request.url?.absoluteString ?? "NO")
        
        if !params.isEmpty {
            guard let jsonData = getDataFromJsonObj(params) else { throw ResponseError.jsonObjectError }
            request.httpBody = jsonData
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue
        
        
        do {
            
            let (data, response) = try await session.data(for: request)
          
            if let responseCode = response as? HTTPURLResponse {
                
                if responseCode.statusCode == 200 {
                    
                    return data
                    
                } else {
                    throw ResponseError.error(responseCode.statusCode)
                }
        
            } else {
                throw ResponseError.somthingWentWrong
            }
            
        } catch {
            
            print(error.localizedDescription)
            throw ResponseError.somthingWentWrong
        }
    }
    
    private func getDataFromJsonObj(_ object: [String: Any]) -> Data? {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: object)
        return jsonData
        
    }
    
}


extension AppRequestHelper {
    
    func downloadMedia(url: URL) async throws -> String {
    
        
        guard let directory = documentDirectoryForSong else { throw ResponseError.documnentDirectoryNil}
        let destinationUrl = directory.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            return destinationUrl.path
            
        } else {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            do {
                let (data, response) = try await session.data(for: request)
                
                
                
                  if let responseCode = response as? HTTPURLResponse {
                      
                      if responseCode.statusCode == 200 {
                          
                          do {
                              try data.write(to: destinationUrl)
                              return destinationUrl.path
                              
                          } catch {
                              throw error
                          }
                          
                      } else {
                          throw ResponseError.error(responseCode.statusCode)
                      }
              
                  } else {
                      throw ResponseError.somthingWentWrong
                  }
                
            } catch {
                print(error.localizedDescription)
                throw ResponseError.somthingWentWrong
            }
        }
    }
    
    
    private func createFolderInDocumentsDirectoryIfNeeded() throws -> URL {
        
        
        let fileManager = FileManager.default
        
        let folderURL = documentsURL.appendingPathComponent("Songs")

        var isDirectory: ObjCBool = false
        
        
        if fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory) {
            
            if isDirectory.boolValue {
                return folderURL
                
            } else {
                // A file with the same name exists, handle appropriately
                throw NSError(domain: "YourDomain", code: 1001, userInfo: [NSLocalizedDescriptionKey: "A file with the same name exists at the specified path."])
            }
        } else {
            // Folder does not exist, create it
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                return folderURL
            } catch {
                throw error
            }
        }
    }
}
