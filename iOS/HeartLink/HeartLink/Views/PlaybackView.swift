//
//  PlaybackView.swift
//  HeartLink
//
//  Created by Matt Wilker on 28/11/2024.
//

import SwiftUI

struct PlaybackView: View {
    @State private var isLinkVisible: Bool = true
    let url = URL(string: "192.168.2.206/heartlink.wav") // hard coding IP address temporarily
    let filename: String = "heartlink.wav" // hard coding .wav file name temporarily
    @State var downloadString: String = "Download File"
    
    var body: some View {
        VStack{
            Color.white.ignoresSafeArea(.all)
            
            if isLinkVisible {
                Link(downloadString, destination: url!) // when hit this link make a bool change so can do conditional if to show this or not
                    .font(.system(size: 42, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .top)
                    .frame(height: 100)
                    .onTapGesture {
                        isLinkVisible = false // not working
                        
                        
                        //downloadString = "File already downloaded"
                        //Text("File already downloaded")
                            //.font(.system(size: 20, weight: .bold))
                            //.frame(maxWidth: .infinity, alignment: .topLeading)
                            //.frame(height: 20)
                    }
            } /*else { // THIS CURRENTLY NOT WORKING
                Text("File already downloaded")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .frame(height: 20)
            }*/
            
            Text(" ") // taking up white space
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 250)
            
            
                
            Text("Play Recording")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .top)
                .frame(height: 20)
            
            Button(action: {
                // ADD (play file with specified file name from files -> downloads -> filename.wav
            })
            {
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            
            /*ForEach(0...9, id: \.self) { number in
                if startBT == true {
                    Text("Val: \(number)") // replace this with values receive from BT
                        .font(.system(size: 12, weight: .black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Values Done")
                        .font(.system(size: 12, weight: .black))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }*/
            
            
            
    
            Text(" ") // taking up white space
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 300)
        }
    }
}


#Preview {
    PlaybackView()
}
