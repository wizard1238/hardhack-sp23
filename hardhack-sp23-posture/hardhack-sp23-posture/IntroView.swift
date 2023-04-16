//
//  IntroView.swift
//  hardhack-sp23-posture
//
//  Created by Jeremy Tow on 4/15/23.
//

import SwiftUI

struct IntroView: View {
    @State var shown: Bool = false
    
    init() {
//        shown = true
    }
    
    func getStarted() {
        
    }
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Better\nPosture\nStarts\nToday")
                        .font(Font.system(size: 84, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .overlay {
                            LinearGradient(
                                colors: [Color(UIColor(named: "pastelGreen")!)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                        .mask(
                            Text("Better Posture\nStarts Today")
                                .font(Font.system(size: 84, weight: .bold))
                                .multilineTextAlignment(.leading)
                        )
                    Spacer()
                    Spacer()
                }
                Spacer()
                Spacer()
                NavigationLink(destination:
                                ContentView()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                               , label: {
                    Image(systemName: "arrow.right")
                      .resizable()
                      .frame(width: 30, height: 30)
                      .foregroundColor(.white)
                      .padding(30)
                      .background(Color(UIColor(named: "pastelGreen")!))
                      .clipShape(Circle())
                    .offset(x: 0, y: shown ? 0 : -1000)
                    .onAppear {
                        withAnimation(.spring(response: 0.3)) {
                            shown = true
                        }
                    }
                    .offset(x: 0, y: shown ? 0 : -700)
                    .animation(.spring(), value: shown)
                })
                Spacer()
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
