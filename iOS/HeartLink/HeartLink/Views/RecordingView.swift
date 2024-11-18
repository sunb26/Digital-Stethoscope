//
//  RecordingView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//  Edited by Matt Wilker on 2024-11-16

import SwiftUI

struct RecordingView: View {
    @State var isRecording: Bool = false
    @State var countdown: Int8 = 0
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack{
            VStack{
                    
                Text(isRecording ? "Recording..." : "Ready to Record")    .font(.system(size: 42, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 100)
                
                Text(countdown == 0 ? " " : "Starts in: \(countdown)")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 400, alignment: .top)
                
                Button(action: {
                    isRecording.toggle()
                    countdown = isRecording ? 3 : 0
                })
                {
                    if !isRecording { // ready to record page
                        Image(systemName: "record.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.red)
                    } else { // recording page
                        Image(systemName: "stop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.red)
                    }
                }
            }
            .onReceive(timer) { time in // decrement timer every second
                if countdown > 0 {
                    countdown -= 1
                }
            }
        }
    }
}

#Preview {
    RecordingView()
}
