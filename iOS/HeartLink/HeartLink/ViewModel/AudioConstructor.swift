//
//  AudioConstruction.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-11-18.
//

import Foundation
import AVFoundation

class AudioConstructor {
    func construct(rawAudio: UnsafeMutableRawPointer, sampleRate: UInt32, numChannels: UInt32, bitDepth: UInt32, recordTime: UInt32, outputURL: URL) throws {
        
        // Prepare the audio format description for .wav using 16-bit PCM 1 channel
        var audioFormat = AudioStreamBasicDescription(
            mSampleRate: Float64(sampleRate),
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
            mBytesPerPacket: UInt32(bitDepth / 8 * numChannels),
            mFramesPerPacket: 1,
            mBytesPerFrame: UInt32(bitDepth / 8 * numChannels),
            mChannelsPerFrame: UInt32(numChannels),
            mBitsPerChannel: UInt32(bitDepth),
            mReserved: 0
        )
        
        // Create an audio file
        var audioFile: ExtAudioFileRef?
        let fileCreationStatus = ExtAudioFileCreateWithURL(
            outputURL as CFURL,
            kAudioFileWAVEType,
            &audioFormat,
            nil,
            AudioFileFlags.eraseFile.rawValue,
            &audioFile
        )
        
        guard fileCreationStatus == noErr else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(fileCreationStatus), userInfo: nil)
        }
        
        // Check if external file ref exists
        guard let extAudioFile = audioFile else { return }
        
        // Calculate byte array size
        let count = numChannels * sampleRate * bitDepth * recordTime / 8;
        
        let audioBuffer = AudioBuffer(
            mNumberChannels: numChannels,
            mDataByteSize: count,
            mData: rawAudio
        )
        
        // ExtAudioFileWrite only takes AudioBufferList so append audioBuffer to the list
        var audioBufferList = AudioBufferList(
            mNumberBuffers: 1,
            mBuffers: audioBuffer
        )
        
        // Write the buffer to the file
        let frameCount = count / (bitDepth / 8 * numChannels)
        let writeStatus = ExtAudioFileWrite(extAudioFile, UInt32(frameCount), &audioBufferList)
        if writeStatus != noErr {
            print("Error writing audio data: \(writeStatus)")
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(writeStatus), userInfo: nil)
        }
        
        // Close the audio file
        ExtAudioFileDispose(extAudioFile)
        
        // TODO (sunb26): Remove after testing
        print("Audio file saved at: \(outputURL.path)")
    }
}

