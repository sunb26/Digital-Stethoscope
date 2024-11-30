//
//  PlaybackView.swift
//  HeartLink
//
//  Created by Matt Wilker on 28/11/2024.
//

import SwiftUI
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers

struct PlaybackView: View {
    let url = URL(string: "http:192.168.2.206/heartlink.wav") // hard coding IP address temporarily
    let filename: String = "heartlink.wav" // hard coding .wav file name temporarily
    @State var downloadString: String = "Download File"
    @State var audioPlayer: AVAudioPlayer?
    
    
    @State var show = false
    
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
                //playWavFile()
                self.show.toggle()
            })
            {
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .bottom)
            }
            .sheet(isPresented: $show) {
                DocumentPicker()
            }
            Text(" ") // taking up white space
                .font(.system(size: 42, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 300)
        }
    }
    
    func playWavFile() {
        /*guard let downloadsPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        else {
            print("Error: Cannot access downloads folder")
            return
        }*/
        let downloadsPath = URL.downloadsDirectory
        /*let accessing = wavFilePath.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                print("before")
                wavFilePath.stopAccessingSecurityScopedResource()
                print("after")
            }
        }*/
        
        
        
        do {
            let items = try FileManager.default.contentsOfDirectory(at: downloadsPath, includingPropertiesForKeys: nil)
            for item in items {
                print("Item: \(item)")
            }
        } catch {
            print("Error: \(error)")
        }
        
        
        let wavFilePath = downloadsPath.appending(components: filename)
        let testBool = FileManager.default.fileExists(atPath: wavFilePath.path)
        print("test bool: \(testBool)")
        
        //let wavFilePath = downloadsPath.appendingPathComponent(filename)
        //let wavFilePath = URL(fileURLWithPath: "/Users/ec2-user/Library/Developer/CoreSimulator/Devices/AAA441DA-8B00-43EA-B3DB-5391E046036D/data/Containers/Data/Application/30F30C05-4033-4D81-827A-DEF7B69092FF/Downloads/heartlink.wav")
        let accessing = wavFilePath.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                print("before")
                wavFilePath.stopAccessingSecurityScopedResource()
                print("after")
            }
        }
        print("accessing: \(accessing)")
        //let wavFilePath = URL(string: ")
        print("File Path: \(wavFilePath.path)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: wavFilePath)
            audioPlayer?.play()
        } catch {
            print("Error when playing audio file: \(error)")
        }
        do { wavFilePath.stopAccessingSecurityScopedResource()
        }
    }
}

//extension UTType {
  //  static let wav = UTType(importedAs: "public.audio")
//}

struct DocumentPicker: UIViewControllerRepresentable {
    var audioPlayer: AVAudioPlayer?
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.wav])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        //let vari = picker.directoryURL
        //print("variable: \(vari)")
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator : NSObject, UIDocumentPickerDelegate {
        var audioPlayer: AVAudioPlayer?
        var parent : DocumentPicker
        
        init(parent1 : DocumentPicker) {
            parent = parent1
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("Within documentPicker")
            print(urls)
            
            print("File Path: \(urls.first!.path)")
            let accessing = urls.first!.startAccessingSecurityScopedResource()
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: urls.first!)
                audioPlayer?.play()
            } catch {
                print("Error when playing audio file: \(error)")
            }
            do { urls.first!.stopAccessingSecurityScopedResource()
            }
        }
    }
    
    
}


#Preview {
    PlaybackView()
}
