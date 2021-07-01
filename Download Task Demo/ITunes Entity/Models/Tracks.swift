//
//  Tracks.swift
//  Download Task Demo
//
//  Created by unthinkable-mac-0025 on 30/06/21.
//

import Foundation

struct Track {
  let artist: String
  let index: Int
  let name: String
  let previewURL: URL
    
  var isDownloaded = false
  var localURL : URL?
}

//// MARK: - Welcome
//struct Tracks: Codable {
//    let resultCount: Int
//    let results: [Track]
//}
//
//// MARK: - Result
//struct Track: Codable {
//    let wrapperType: WrapperType
//    let kind: Kind
//    let artistID, collectionID, trackID: Int
//    let artistName, collectionName, trackName, collectionCensoredName: String
//    let trackCensoredName: String
//    let artistViewURL, collectionViewURL, trackViewURL: String
//    let previewURL: String
//    let artworkUrl30, artworkUrl60, artworkUrl100: String
//    let collectionPrice, trackPrice: Double
//    let releaseDate: Date
//    let collectionExplicitness, trackExplicitness: Explicitness
//    let discCount, discNumber, trackCount, trackNumber: Int
//    let trackTimeMillis: Int
//    let country: Country
//    let currency: Currency
//    let primaryGenreName: String
//    let isStreamable: Bool
//    let contentAdvisoryRating: String?
//    let collectionArtistID: Int?
//    let collectionArtistName: String?
//    let collectionArtistViewURL: String?
//
//    enum CodingKeys: String, CodingKey {
//        case wrapperType, kind
//        case artistID = "artistId"
//        case collectionID = "collectionId"
//        case trackID = "trackId"
//        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
//        case artistViewURL = "artistViewUrl"
//        case collectionViewURL = "collectionViewUrl"
//        case trackViewURL = "trackViewUrl"
//        case previewURL = "previewUrl"
//        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable, contentAdvisoryRating
//        case collectionArtistID = "collectionArtistId"
//        case collectionArtistName
//        case collectionArtistViewURL = "collectionArtistViewUrl"
//    }
//}
//
//enum Explicitness: String, Codable {
//    case explicit = "explicit"
//    case notExplicit = "notExplicit"
//}
//
//enum Country: String, Codable {
//    case usa = "USA"
//}
//
//enum Currency: String, Codable {
//    case usd = "USD"
//}
//
//enum Kind: String, Codable {
//    case song = "song"
//}
//
//enum WrapperType: String, Codable {
//    case track = "track"
//}
