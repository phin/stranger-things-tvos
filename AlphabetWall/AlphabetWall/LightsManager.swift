//
//  LightsManager.swift
//  AlphabetWall
//
//  Created by Séraphin Hochart on 16-10-13.
//  Copyright © 2016 Séraphin Hochart. All rights reserved.
//

import Foundation
import UIKit

class LightColors {
    static let redColor = UIColor.red
    static let whiteColor = UIColor.white
    static let orangeColor = UIColor.orange
    static let yellowColor = UIColor.yellow
    static let greenColor = UIColor.green
    static let blueColor = UIColor(colorLiteralRed: 30.0/255.0, green: 144.0/255.0, blue: 1.0, alpha: 1.0)
}

enum Light: String {

    case A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z

    func data() -> (CGPoint, UIColor) {
        switch self {

        // IMG is 816 x 544
        case .A: return (CGPoint(x: 181.0, y: 72.0), LightColors.whiteColor)
        case .B: return (CGPoint(x: 254.0, y: 75.0), LightColors.blueColor)
        case .C: return (CGPoint(x: 310.0, y: 84.0), LightColors.redColor)
        case .D: return (CGPoint(x: 404.0, y: 100.0), LightColors.greenColor)
        case .E: return (CGPoint(x: 457.0, y: 104.0), LightColors.blueColor)
        case .F: return (CGPoint(x: 553.0, y: 123.0), LightColors.orangeColor)
        case .G: return (CGPoint(x: 608.0, y: 115.0), LightColors.redColor)
        case .H: return (CGPoint(x: 674.0, y: 113.0), LightColors.blueColor)
        case .I: return (CGPoint(x: 78.0, y: 171.0), LightColors.redColor)
        case .J: return (CGPoint(x: 191.0, y: 206.0), LightColors.redColor)
        case .K: return (CGPoint(x: 258.0, y: 219.0), LightColors.blueColor)
        case .L: return (CGPoint(x: 334.0, y: 224.0), LightColors.greenColor)
        case .M: return (CGPoint(x: 410.0, y: 230.0), LightColors.yellowColor)
        case .N: return (CGPoint(x: 469.0, y: 207.0), LightColors.redColor)
        case .O: return (CGPoint(x: 536.0, y: 200.0), LightColors.orangeColor)
        case .P: return (CGPoint(x: 600.0, y: 206.0), LightColors.greenColor)
        case .Q: return (CGPoint(x: 735.0, y: 221.0), LightColors.redColor)
        case .R: return (CGPoint(x: 133.0, y: 313.0), LightColors.greenColor)
        case .S: return (CGPoint(x: 204.0, y: 332.0), LightColors.whiteColor)
        case .T: return (CGPoint(x: 265.0, y: 351.0), LightColors.yellowColor)
        case .U: return (CGPoint(x: 357.0, y: 346.0), LightColors.blueColor)
        case .V: return (CGPoint(x: 427.0, y: 349.0), LightColors.redColor)
        case .W: return (CGPoint(x: 492.0, y: 342.0), LightColors.greenColor)
        case .X: return (CGPoint(x: 550.0, y: 348.0), LightColors.yellowColor)
        case .Y: return (CGPoint(x: 622.0, y: 331.0), LightColors.redColor)
        case .Z: return (CGPoint(x: 719.0, y: 338.0), LightColors.orangeColor)
        }
    }

    static let allValues = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z]
    static func lightFromString(string: String) -> Light? {
        for light in Light.allValues {
            if light.rawValue == string {
                return light
            }
        }
        return nil
    }
}

class LightsManager {
    
    static let sharedManager = LightsManager()
    var alphabetView: UIImageView?
    var inUse = false

    private var lastLightView: LightView?

    private let timePerLetter: Double = 1.0
    private let timeBetweenLetters: Double = 0.2
    private let alphabetViewScale: CGFloat = 2.36
    private let alphabetViewWidth: CGFloat = 100
    
    private var currentStringIndex = 0
    private var characters:[Light?] = []
    private var timer: Timer?

    func showString(string: String) {
        
        resetManager()
        inUse = true
        
        // TODO : trim so we only get clean alphabet letters, put all caps
        let uppercaseString = string.uppercased()

        for (_, letter) in uppercaseString.characters.enumerated() {
            characters.append(Light.lightFromString(string: "\(letter)"))
        }
        characters.append(nil) // 1 sec pause
        
        timer = Timer.scheduledTimer(withTimeInterval: timePerLetter, repeats: true) { (timer) in
            self.lightNext()
        }
    }
    
    // MARK: - Private
    
    private func done() {
        inUse = false
        resetManager()
        CommunicationManager.sharedManager.readyForNextMessage()
    }
    
    private func lightNext() {
        if currentStringIndex < characters.count {
            let nextLight =  characters[currentStringIndex]
            light(light: nextLight)
            currentStringIndex += 1
        } else {
            done()
        }
    }
    
    private func resetManager() {
        turnAllLightsOff()
        currentStringIndex = 0
        characters.removeAll()
        timer?.invalidate()
        timer = nil
    }
    
    private func light(light: Light?) {
        self.turnAllLightsOff()
        if let light = light {
            print("SHOW LIGHT \(light.rawValue)")
            self.setupLightView(light.data().0, color: light.data().1)
        }
    }
    
    private func turnAllLightsOff() {
        self.lastLightView?.removeFromSuperview()
    }
    private func setupLightView(_ point: CGPoint, color: UIColor) {
        let light = LightView(frame: CGRect(
            x: point.x * alphabetViewScale - alphabetViewWidth * 0.5,
            y: point.y * alphabetViewScale - alphabetViewWidth * 0.5,
            width: alphabetViewWidth,
            height: alphabetViewWidth), color: color, duration: timePerLetter)
        lastLightView = light
        alphabetView?.addSubview(light)
    }
}
