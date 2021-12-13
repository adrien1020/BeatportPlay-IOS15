//
//  AirPlayView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 13/12/2021.
//

import Foundation
import SwiftUI
import AVKit

struct AirPlayView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let avRoutePickerView = AVRoutePickerView()
        avRoutePickerView.backgroundColor = .clear
        avRoutePickerView.tintColor = .white
        avRoutePickerView.activeTintColor = .red
        return avRoutePickerView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
