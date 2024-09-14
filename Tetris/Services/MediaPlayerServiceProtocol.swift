//
//  MediaPlayerServiceProtocol.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
protocol MediaPlayerServiceProtocol {
    func play(songName: String, resourceExtension: String)
    func stop()
}
