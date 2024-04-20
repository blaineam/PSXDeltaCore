//
//  PSX.swift
//  PSXDeltaCore
//
//  Created by Ian Clawson on 9/13/20.
//

import Foundation
import AVFoundation

import DeltaCore
@_exported import PSXBridge
@_exported import PSXSwift

extension PSXGameInput: Input
{
    public var type: InputType {
        return .game(.psx)
    }
}

public struct PSX: DeltaCoreProtocol
{
    public static let core = PSX()
    
    public var name: String { "PSXDeltaCore" }
    public var identifier: String { "com.rileytestut.PSXDeltaCore" }
    
    public var gameType: GameType { GameType.psx }
    public var gameInputType: Input.Type { PSXGameInput.self }
    public var gameSaveFileExtension: String { "mcr" }
        
    public let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 2, interleaved: true)!
    public let videoFormat = VideoFormat(format: .bitmap(.bgra8), dimensions: CGSize(width: 768, height: 480), preferredAspectRatio: CGSize(width: 4, height: 3))
    public var supportedCheatFormats: Set<CheatFormat> {
        return []
    }
    
    public var emulatorBridge: EmulatorBridging { PSXEmulatorBridge.shared as! EmulatorBridging }
    
    public var resourceBundle: Bundle { Bundle.module }
        
    private init()
    {
    }
}
