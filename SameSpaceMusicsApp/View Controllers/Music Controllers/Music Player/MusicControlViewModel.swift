//
//  MusicControlViewModel.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 20/01/24.
//

import Foundation


class MusicControlViewModel {
    
    var filePath = ""
    
    var bind:((ResponseStatus) -> ()) = { _ in }
    
    
    func fetchMusic(url: String) {
        
        bind(.loading)
        
        Task {
            do {
                let filepathOfMusic = try await AppRequestManager.shared.fetchMediaFile(urlString: "")
                filePath = filepathOfMusic
                bind(.success)
                
            } catch {
            
                bind(.failed(error.localizedDescription))
            }
        }
    }
}
