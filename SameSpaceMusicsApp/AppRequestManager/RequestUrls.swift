//
//  RequestUrls.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 18/01/24.
//

import Foundation


enum AppMode {
    case UAT
    case Live
}

var appMode = AppMode.UAT

enum RequestUrls: String {
    
    case songs = "items/songs"
    case coverImage = "assets/"

    static var baseUrl: String {
        switch appMode {
        case .UAT:
            return "https://cms.samespace.com/"
        case .Live:
            return ""
        }
    }
}
