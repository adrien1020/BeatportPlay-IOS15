//
//  ListViewModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 29/09/2021.
//

import Foundation
import UIKit
import SwiftUI

class ListViewModel: ObservableObject {
    @Published var beatportData = [BeatPortModel]()
    @Published var setUrl: String = ""
    @Published var isdownload = false
    @Published var error = ""
    @Published var showAlert = false
    @AppStorage("top100", store: UserDefaults(suiteName: "group.com.BeatportPlay")) var datatop100: Data = Data()
    func getBeatPortData(_ url: String, _ token: String) {
        self.setUrl = url
        self.showAlert = false
        self.isdownload = true
        var url = URLRequest(url: URL(string: url)!)
        url.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode([BeatPortModel].self, from: safeData)
                            DispatchQueue.main.async {
                                self.beatportData = results.sorted { $0.id < $1.id }
                                self.datatop100 = safeData
                                self.isdownload = false
                                self.error = ""
                                self.showAlert = false
                            }
                        } catch {
                            DispatchQueue.main.async {
                            self.error = error.localizedDescription
                                self.showAlert = true
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.error = error!.localizedDescription
                        self.showAlert = true
                    }
                }
            }
            task.resume()
    }
    func getData(_ widgetData: Data, completion: @escaping([BeatPortModel]) -> Void) {
        guard let data = try?JSONDecoder().decode([BeatPortModel].self, from: widgetData)else {return}
        completion(data.sorted {$0.id < $1.id})
    }
}
