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
    @State private var player = AVPlayer()
    @State private var duration: Double = 0
    @State private var currentTime: Double = 0
    @State private var timer: Timer?

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
                                    .scrollDisabled(false)
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

            // Progress Bar
            if duration > 0 {
                Slider(value: $currentTime, in: 0 ... duration, onEditingChanged: sliderEditingChanged)
                    .padding()

                // Timestamps
                HStack {
                    Text(formatTime(currentTime)) // Current time
                    Spacer()
                    Text(formatTime(duration)) // Total duration
                }
                .padding(.horizontal)
                Button(action: self.playPause, label: {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable()
                }).frame(width: 70, height: 70, alignment: .center)
            } else {
                Text("Loading ...")
            }
        }
        .onAppear(perform: setupPlayer)
    }

    func setupPlayer() {
        let storage = Storage.storage().reference(forURL: recording.fileURL)
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
                self.player = AVPlayer(url: url!)

                Task {
                    let totalTime = try await player.currentItem?.asset.load(.duration)
                    self.duration = totalTime?.seconds ?? 0
                }
            }
        }
    }

    func playPause() {
        isPlaying.toggle()
        if isPlaying {
            player.play()
            startTimer()
        } else {
            player.pause()
            stopTimer()
        }
    }

    func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            stopTimer()
        } else {
            let targetTime = CMTime(seconds: currentTime, preferredTimescale: 600)
            player.seek(to: targetTime)
            if isPlaying {
                startTimer()
            }
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let currentTimeValue = player.currentItem?.currentTime().seconds {
                self.currentTime = currentTimeValue
                if self.currentTime == self.duration {
                    self.isPlaying = false
                    self.currentTime = 0
                    self.player.seek(to: .zero)
                    stopTimer()
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    @Previewable @State var path: [PageActions] = [.recording]
    @Previewable @State var record = RecordingData(id: 0, date: "2025-01-01", viewed: true, comments: "Test", fileURL: "gs://heartlink-6fee0.firebasestorage.app/recordings/chillin39-20915.wav")
    RecLogView(path: $path, recording: $record)
}
