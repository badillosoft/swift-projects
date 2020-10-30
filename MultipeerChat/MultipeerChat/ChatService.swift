//
//  ChatService.swift
//  MultipeerChat
//
//  Created by Dragon on 30/10/20.
//

import Foundation
import MultipeerConnectivity

protocol ChatServiceDelegate {
    
    func connectedDevicesChanged(manager : ChatService, connectedDevices: [String])
    func messageReceived(manager : ChatService, message: String)
    
}

// Servicio de control y transporte de chats
class ChatService: NSObject {
    
    //lazy var a : Int = { return 123 }()
    
    var deletegate: ChatServiceDelegate?
    
    // Nombre del servicio reconocible
    let serviceName = "chat-service"
    
    // Identidad del nodo del dispositivo
    let peerId = MCPeerID(displayName: UIDevice.current.name)
    
    // Servicio de recepción invitaciones (aceptar/rechazar)
    let serviceAdvertiser: MCNearbyServiceAdvertiser
    // Servicio de descubrimiento de nodos y envío invitaciones
    let serviceBrowser: MCNearbyServiceBrowser
    // Servicio de control de sesiones
    lazy var session : MCSession = {
        let session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    var isBrowsing = false
    
    override init() {
        // Construimos los servicios
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.peerId, discoveryInfo: nil, serviceType: serviceName)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.peerId, serviceType: self.serviceName)
        
        super.init()
        
        // Iniciamos los servicios
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        // Detenemos los servicios
        self.serviceAdvertiser.stopAdvertisingPeer()
        if isBrowsing {
            self.serviceBrowser.stopBrowsingForPeers()
        }
    }
    
    func startBrowser() {
        NSLog("%@", "startBrowser obsoleto")
        //self.serviceBrowser.startBrowsingForPeers()
        //isBrowsing = true
    }
    
    func sendMessage(message: String) {
        NSLog("%@", "sendMessage: \(message) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
}

// Control de invitaciones
extension ChatService: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    // Acepta o rechaza una invitación solicitada
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        // TODO: Lógica para aceptar o rechazar una invitación
        invitationHandler(true, self.session)
    }
    
}

// Control de búsqueda de nodos
extension ChatService: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    // Cuándo se encuentra un nodo, envía una invitación de emparejamiento
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        self.serviceBrowser.invitePeer(self.peerId, to: self.session, withContext: nil, timeout: 60)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}

// Control de sesiones y recepción de datos
extension ChatService: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        //self.deletegate?.
        if let delegate = self.deletegate {
            delegate.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
            //delegate.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{peer in peer.displayName})
            return
        }
        NSLog("%@", "Error: No hay delegado de ChatServiceDelegate implementado")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        if let delegate = self.deletegate {
            if let message = String(data: data, encoding: .utf8) {
                delegate.messageReceived(manager: self, message: message)
            }
        }
        //let message = String(data: data, encoding: .utf8)!
        //delegate?.messageReceived(manager: self, message: message)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
