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
        
        
        print("Whats")
        bind(.loading)
        
        Task {
            do {
                let filepathOfMusic = try await AppRequestManager.shared.fetchMediaFile(urlString: url)
                filePath = filepathOfMusic
                bind(.success)
                
                print("Whats v")
            } catch {
                print("Whats s")
                bind(.failed(error.localizedDescription))
            }
        }
    }
}
