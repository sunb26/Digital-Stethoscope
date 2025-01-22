//
//  RecLogView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-12-20.
//
// Displays the data for a specific recording.

import AVFoundation
import FirebaseStorage
import SwiftUI

struct RecLogView: View {
    @Binding var path: [PageActions]
    @Binding var recording: RecordingData
    @State var isPlaying: Bool = false
    @State var player = AVPlayer()

    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Recording")
                        .font(.title).fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("ID: \(recording.id)")
                    if recording.viewed {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("View Status:")
                                Text("Viewed")
                                    .foregroundStyle(.green)
                            }
                            VStack(alignment: .leading) {
                                Text("Comments: ")
                                    .font(.title2)
                                    .bold()
                                Text(recording.comments)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 20))
                            }
                            .padding(.top, 25)
                        }
                    } else {
                        HStack {
                            Text("View Status:")
                            Text("Not Viewed")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)

            Button(action: self.playPause, label: {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable()
            }).frame(width: 70, height: 70, alignment: .center)
        }
        .onAppear {
            let storage = Storage.storage().reference(forURL: self.recording.fileURL)
            storage.downloadURL { url, error in
                if error != nil {
                    print("display recording data: \(String(describing: error))")
                } else {
                    do {
                        try
                            // Playback even with notifications silenced
                            AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    } catch {
                        print("display recording data: \(String(describing: error))")
                    }
                    player = AVPlayer(url: url!)
                }
            }
        }
    }

    func playPause() {
        isPlaying.toggle()
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
}

#Preview {
    @Previewable @State var path: [PageActions] = [.recording]
    @Previewable @State var record = RecordingData(id: 0, date: "2025-01-01", viewed: true, comments: "Test", fileURL: "gs://heartlink-6fee0.firebasestorage.app/recordings/chillin39-20915.wav")
    RecLogView(path: $path, recording: $record)
}
