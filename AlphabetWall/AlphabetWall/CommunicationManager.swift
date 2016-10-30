//
//  CommunicationManager.swift
//  AlphabetWall
//
//  Created by Séraphin Hochart on 16-10-13.
//  Copyright © 2016 Séraphin Hochart. All rights reserved.
//

import Foundation

class CommunicationManager {
    
    // Retrieve signals from Twitter/Sms and call the LightsManager

    
    private var url = URL(string:"http://yourserver.com/sms.json") <#todo#>// Change the var to your server!
    private var resetUrl = URL(string:"http://yourserver.com/reset.php") <#todo#>// Change the var to your server!
    private var messages:[Message] = []
    private var remoteList:[Message] = [] // If we directly modify the list we risk race conditions
    private let interval = 20.0
    
    private var currentMessageIndex = 0
    
    static let sharedManager = CommunicationManager()
    
    func start() {
        // Reset server
        let resetData = URLSession.shared.dataTask(with: resetUrl!) { (data, response, error) in
            DispatchQueue.main.async {
                self.startTimer()
            }
        }
        resetData.resume()
    }
    
    func readyForNextMessage() {
        // TODO : Make Lights Manager start the next message
        syncServerList() // Update in between requests
        
        if currentMessageIndex >= messages.count {
            return
        }
        
        let nextMessage = messages[currentMessageIndex].body
        LightsManager.sharedManager.showString(string: nextMessage)
        currentMessageIndex += 1
    }

    // MARK: - Private
    
    private func startTimer() {
        updateDataFromServer()
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
            self.updateDataFromServer()
        }
    }
    
    private func syncServerList() {
        if remoteList.count < messages.count {
            currentMessageIndex = 0 // We have a new list, we can start over
        }
        messages = remoteList
    }

    private func updateDataFromServer() {

        guard let url = url else {
            return
        }
        URLSession.shared.invalidateAndCancel()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error! as Error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.remoteList.removeAll()

            // PARSE JSON
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            if let jsonArray = json as? [[String: String]] {
                for message in jsonArray {
                    if let from = message["from"], let body = message["body"] {
                        self.remoteList.append(Message(from: from, body: body))
                    }
                }
            }

            dump(self.remoteList)
            
            DispatchQueue.main.async {
                self.processServerList()
            }
        }
        
        task.resume()
    }
    
    private func processServerList() {
        if self.messages.count == 0 {
            readyForNextMessage() // First message
        } else {
            // If the lights manager is not in use, call readyForNextMessage if :
            // - the # of message is different
            
            if LightsManager.sharedManager.inUse {
                // readyForNextMessage will be called when it's over
            } else {
                readyForNextMessage()
            }
        }
    }
}

struct Message {
    var from: String
    var body: String
}
