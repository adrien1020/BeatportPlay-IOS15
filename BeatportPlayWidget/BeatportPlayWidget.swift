//
//  BeatportPlayWidget.swift
//  BeatportPlayWidget
//
//  Created by Adrien Surugue on 02/12/2021.
//

import WidgetKit
import SwiftUI

struct Top100Entry: TimelineEntry {
    let date: Date
    let top100: [BeatPortModel]
    let images: [UIImage]
}
struct Provider: TimelineProvider {
    @AppStorage("top100", store: UserDefaults(suiteName: "group.com.BeatportPlay"))
    var datatop100: Data = Data() // stored from BeatportData locate in ListViewModel
    func placeholder(in context: Context) -> Top100Entry {
        var images = [UIImage]()
        for index in 0...4 {
            images.append(UIImage(imageLiteralResourceName: FakeModel.fakeTop5Snapeshot[index].image))
        }
        if context.isPreview && datatop100.isEmpty {
            let loadinData = Top100Entry(date: Date(), top100: FakeModel.fakeTop5Snapeshot, images: images)
            return(loadinData)
        } else {
            let loadinData = Top100Entry(date: Date(), top100: FakeModel.fakeTop5Snapeshot, images: images)
            return(loadinData)
        }
    }
    /*Is call in the widget gallery*/
    func getSnapshot(in context: Context, completion: @escaping (Top100Entry) -> Void) {
        if context.isPreview && datatop100.isEmpty {
            // Return a fake data if datatop100 is empty when the widget appears in the widget gallery.
            var images = [UIImage]()
            for index in 0...4 {
                images.append(UIImage(imageLiteralResourceName: FakeModel.fakeTop5Snapeshot[index].image))
            }
            let snapshotFakeData = Top100Entry(date: Date(), top100: FakeModel.fakeTop5Snapeshot, images: images)
            completion(snapshotFakeData)
        } else {
            // Return data if datatop100 is not empty when the widget appears in the widget gallery.
            var images = [UIImage]()
            let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
            getData(datatop100, completion: { widgetData in
                for index in 0...4 {
                    let url = URL(string: widgetData[index].image)
                    let task = URLSession.shared.dataTask(with: url!) { data, _, _ in
                        images.append(UIImage(data: data!)!)
                        semaphore.signal()
                    }
                    task.resume()
                    semaphore.wait()
                }
                let snapshotData = Top100Entry(date: Date(), top100: widgetData, images: images)
                completion(snapshotData)
            })
        }
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Top100Entry>) -> Void) {
        getData(datatop100, completion: { widgetData in
            var images = [UIImage]()
            let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
            for index in 0...4 {
                if let url = URL(string: widgetData[index].image) {
                    let task = URLSession.shared.dataTask(with: url) { data, _, error in
                        if error == nil {
                            images.append(UIImage(data: data!)!)
                            semaphore.signal()
                        }
                    }
                    task.resume()
                    semaphore.wait()
                }
            }
            let data = Top100Entry(date: Date(), top100: widgetData, images: images)
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
            let timeline = Timeline(entries: [data], policy: .after(nextUpdate!))
            completion(timeline)
        })
    }
    func getData(_ widgetData: Data, completion: @escaping([BeatPortModel]) -> Void) {
        guard let data = try?JSONDecoder().decode([BeatPortModel].self, from: widgetData)else {return}
        completion(data.sorted {$0.id < $1.id})
    }
}

struct BeatportListEntryView: View {
    var data: Provider.Entry
    var body: some View {
        VStack {
            HStack {
                Image("beatport.logo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .frame(width: 22, height: 22)
                Text("BeatportPlay")
                    .textCase(.uppercase)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 12)
            VStack(spacing: 8) {
                ForEach(0...4, id: \.self) {index in
                    HStack {
                        Image(uiImage: data.images[index])
                            .resizable()
                            .frame(width: 45, height: 45)
                            .scaledToFit()
                            .cornerRadius(10)
                        HStack(spacing: 10) {
                            Text("\(data.top100[index].id)")
                                .fontWeight(.regular)
                                .font(.caption)
                            VStack(alignment: .leading) {
                                Text(data.top100[index].artist)
                                    .fontWeight(.regular)
                                    .font(.caption)
                                    .lineLimit(1)
                                Text(data.top100[index].title)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        Spacer()
                    }
                    .padding(.leading, 8)
                    if index<4 {
                        Divider()
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 12)
    }
}

struct BeatportImageEntryView: View {
    var data: Provider.Entry
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Image("beatport.logo")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .frame(width: 22, height: 22)
                    Text("BeatportPlay")
                        .textCase(.uppercase)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 12)
            Spacer()
                HStack(spacing: 6) {
                    ForEach(0...2, id: \.self) {index in
                        Image(uiImage: data.images[index])
                            .resizable()
                            .cornerRadius(10)
                            .scaledToFill()
                            .frame(height: geometry.size.height/2.5)
                    }
                }
                .padding(.horizontal, 10)
                Spacer()
            }
            .padding(.vertical, 10)
        }
    }
}

struct BeatportImageWidget: Widget {
    private let kind: String = "BeatportImageWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: {entry in
            BeatportImageEntryView(data: entry)
        })
            .supportedFamilies([.systemMedium])
    }
}

struct BeatportTop3Widget: Widget {
    private let kind: String = "BeatportTop3Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: {entry in
            BeatportListEntryView(data: entry)
        })
            .supportedFamilies([.systemExtraLarge, .systemLarge])
    }
}

@main
struct BeatportPlayWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        BeatportTop3Widget()
        BeatportImageWidget()
    }
}
