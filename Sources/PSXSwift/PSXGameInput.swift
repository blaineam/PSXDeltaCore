//
//  PSXGameInput.swift
//  
//
//  Created by Ian Clawson on 4/17/21.
//

import DeltaCore

// Declared in PSXSwift so we can use it from PSXBridge.
@objc public enum PSXGameInput: Int, _Input
{
    // D-Pad
    case up     = 0
    case down   = 1
    case left   = 2
    case right  = 3

    // Left Analog-Stick
    case leftAnalogStickUp      = 4
    case leftAnalogStickDown    = 5
    case leftAnalogStickLeft    = 6
    case leftAnalogStickRight   = 7

    // Right Analog-Stick
    case rightAnalogStickUp     = 8
    case rightAnalogStickDown   = 9
    case rightAnalogStickLeft   = 10
    case rightAnalogStickRight  = 11

    // Other
    case triangle   = 12
    case circle     = 13
    case cross      = 14
    case square     = 15
    case l1         = 16
    case l2         = 17
    case l3         = 18
    case r1         = 19
    case r2         = 20
    case r3         = 21
    case start      = 22
    case select     = 23
}

// in mednafen map
//@objc public enum PSXGameInput: Int, _Input
//{
//    // D-Pad
//    case up     = 4
//    case down   = 6
//    case left   = 7
//    case right  = 5
//
//    // Left Analog-Stick
//    case leftAnalogStickUp      = 24
//    case leftAnalogStickDown    = 23
//    case leftAnalogStickLeft    = 22
//    case leftAnalogStickRight   = 21
//
//    // Right Analog-Stick
//    case rightAnalogStickUp     = 20
//    case rightAnalogStickDown   = 19
//    case rightAnalogStickLeft   = 18
//    case rightAnalogStickRight  = 17
//
//    // Other
//    case triangle   = 12
//    case circle     = 13
//    case cross      = 14
//    case square     = 15
//    case l1         = 10
//    case l2         = 8
//    case l3         = 1
//    case r1         = 11
//    case r2         = 9
//    case r3         = 2
//    case start      = 3
//    case select     = 0
//}
