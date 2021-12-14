//
//  SliderMenuView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 30/09/2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct SliderMenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var listVM: ListViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var sliderMenuVM = SliderMenuViewModel()
    @State var bottomSafe = UIApplication.shared.windows.first?.safeAreaInsets.bottom
    @Binding var slideMenuBackgroundBlank: CGFloat
    @Binding var navigationTitle: String
    @Binding var x: CGFloat
    @Binding var width: CGFloat
    @Binding var isOpen: Bool
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 15) {
                        Image("beatport.logo")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .padding(.leading, 12)
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Text("Beatport")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Top 100")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("top.100.color"))
                            }
                            Text("By Genre")
                                .foregroundColor(.white)
                        }
                    }
                    Divider()
                    ScrollView {
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(sliderMenuVM.dataSourceModel) { dataSource in
                                    Button(action: {listVM.getBeatPortData(dataSource.api, loginVM.token)
                                           self.navigationTitle = dataSource.genre
                                        withAnimation {
                                            self.isOpen = false
                                            self.x = -width
                                        }
                                    }, label: {
                                        Text(dataSource.genre)
                                            .foregroundColor(colorScheme == .dark ? .white : .white)
                                            .fontWeight(.semibold)
                                            .frame(width: UIScreen.main.bounds.width-150, alignment: .leading)
                                    })
                                }
                            }
                            .padding(.top, 10)
                            .padding(.leading, 20)
                            .padding(.bottom, bottomSafe)
                            Spacer()
                        }
                    }
                }
                .frame(width: geometry.size.width - slideMenuBackgroundBlank)
                .padding(.top, 50)
                .background(Color.black.opacity(0.5))
                .background(Material.thickMaterial)
                .ignoresSafeArea(.all)
            }
        }
    }
}

@available(iOS 15.0, *)
struct SliderMenuView_Previews: PreviewProvider {
    @State static var slideMenuBackgroundBlank: CGFloat = 100
    @State static var navigationTitle: String = "Main"
    @State static var currentNavigationTitle: String = ""
    @State static var isSelected: Bool = false
    @State static var x: CGFloat = 0
    @State static var width: CGFloat = 0
    @State static var isOpen: Bool = false
    static var previews: some View {
        SliderMenuView(slideMenuBackgroundBlank: $slideMenuBackgroundBlank,
                       navigationTitle: $navigationTitle,
                        x: $x, width: $width, isOpen: $isOpen)
    }
}
