//
//  MusicViewModel.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 20/01/24.
//

import Foundation


class MusicViewModel {

    var songsModelElemetArray = [MusicModelElement]()
    var bindData:((ResponseStatus) -> ()) = {_ in }
    
    
    func fetchSong() async {

        bindData(.loading)
        do {
            let songsModelData = try await AppRequestManager.shared.fetchDataServicePost(MusicModel.self, .songs, httpMethod: .get)
            songsModelElemetArray = songsModelData.data
            bindData(.success)
            
        } catch {
            bindData(.failed)
        }
        
    }
}
