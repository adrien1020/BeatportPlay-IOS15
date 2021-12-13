//
//  PlayerViewModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 04/10/2021.

import Foundation

class PlayerViewModel: ObservableObject {
    private var youTubeApiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Property List", ofType: "plist") else {
          fatalError("Couldn't find file 'Property List'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "YOUTUBE_API_KEY") as? String else {
          fatalError("Couldn't find key 'YOUTUBE_API_KEY' in 'Property List'.")
        }
        return value
      }
    }
    func loadYoutubeVideoId(_ query: String, completionHandler: @escaping (_ youtubeData: YoutubeModel) -> Void) {
        /* Request to fetch video_id on Youtube API V3 with query = "artist+title+remixers".
         The API KEY is stored in the property list file */
        if var urlcomps = URLComponents(string: "https://www.googleapis.com/youtube/v3/search") {
            let session = URLSession(configuration: .default)
            let queryitems = [URLQueryItem(name: "parts", value: "snippet"),
                              URLQueryItem(name: "maxResults", value: "1"),
                              URLQueryItem(name: "key", value: youTubeApiKey),
                              URLQueryItem(name: "q", value: query)]
            urlcomps.queryItems = queryitems
            let url  = urlcomps.url
            let task = session.dataTask(with: url!) { (data, _, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(YoutubeModel.self, from: safeData)
                            DispatchQueue.main.async {
                                completionHandler(results)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(error!.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    func convertTime(_ seconds: Float) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.collapsesLargestUnit = false
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return(formattedString)
    }
}
