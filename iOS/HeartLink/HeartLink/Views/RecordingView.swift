//
//  RecordingView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//

import SwiftUI

struct RecordingView: View {
    @State var isRecording: Bool = false
    var body: some View {
        VStack{
            Text(isRecording ? "Recording..." : "Ready to Record")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 400)
            
            
            Button(action: {
                isRecording.toggle()
            }) {
                if !isRecording {
                    Image(systemName: "record.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    RecordingView()
}
