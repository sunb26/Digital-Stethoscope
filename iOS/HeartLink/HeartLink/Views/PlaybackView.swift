//
//  PlaybackView.swift
//  HeartLink
//
//  Created by Matt Wilker on 28/11/2024.
//

import SwiftUI
import AVFoundation

struct PlaybackView: View {
    let url = URL(string: "http:192.168.2.206/heartlink.wav") // hard coding IP address temporarily
    let filename: String = "heartlink.wav" // hard coding .wav file name temporarily
    @State var downloadString: String = "Download File"
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack{
            Color.white.ignoresSafeArea(.all)
            
            Link(downloadString, destination: url!)
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .top)
                .frame(height: 100)
                    
            Text(" ") // taking up white space
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 250)

            Text("Play Recording")
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .top)
                .frame(height: 20)
            
            Text(" ") // taking up white space
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 10)
            
            Button(action: {
                // play file with specified file name from files -> downloads -> filename.wav
                playWavFile()
            })
            {
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .bottom)
            }
            Text(" ") // taking up white space
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 300)
        }
    }
    
    func playWavFile() {
        guard let downloadsPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        else {
            print("Error: Cannot access downloads folder")
            return
        }
        
        let wavFilePath = downloadsPath.appendingPathComponent(filename)
        //let wavFilePath = URL(string: ")
        print("File Path: \(wavFilePath.absoluteString)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: wavFilePath)
            audioPlayer?.play()
        } catch {
            print("Error when playing audio file: \(error)")
        }
    }
}


#Preview {
    PlaybackView()
}
