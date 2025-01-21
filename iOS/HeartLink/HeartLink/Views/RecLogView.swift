//
//  RecLogView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-12-20.
//
// Displays the data for a specific recording.

import SwiftUI

struct RecLogView: View {
    @Binding var path: [PageActions]
    @Binding var recording: RecordingData

    var body: some View {
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
    }
}

#Preview {
    @Previewable @State var path: [PageActions] = [.recording]
    @Previewable @State var record = RecordingData(id: 0, date: "2025-01-01", viewed: true, comments: "Test")
    RecLogView(path: $path, recording: $record)
}
