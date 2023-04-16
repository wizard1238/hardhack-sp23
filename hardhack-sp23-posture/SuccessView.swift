//
//  SuccessView.swift
//  hardhack-sp23-posture
//
//  Created by Jeremy Tow on 4/16/23.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text("Success")
                .font(Font.system(size: 72, weight: .bold))
                .multilineTextAlignment(.leading)
                .overlay {
                    LinearGradient(
                        colors: [Color(UIColor(named: "pastelGreen")!)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
                .mask(
                    Text("Success")
                        .font(Font.system(size: 72, weight: .bold))
                        .multilineTextAlignment(.leading)
                )
        }
        .task {
            var url = URL(string: "http://jeremyztow.com:1024/start")!
            let task = URLSession.shared.dataTask(with: url){
                    data, response, error in
                    
                    if let data = data, let string = String(data: data, encoding: .utf8){
                        print(string)
                    }
                }

                task.resume()
        }
        .edgesIgnoringSafeArea(.all)
    }
}
