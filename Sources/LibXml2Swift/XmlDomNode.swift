//
//  XmlDomNode.swift
//  LibXml2Swift
//
//  Created by Dami on 12/10/2016.
//
//

import Foundation
import CLibxml

public enum XmlParserError : Error {
    case noFound(atUrl: URL)
    case unknownError(msg: String)
    case noNode(msg: String)
    case invalidType(type: XmlDomNodeType, real: XmlDomNodeType?)
}

public enum XmlDomNodeType : UInt32 {
    case element = 1 // XML_ELEMENT_NODE
    case text = 3 // XML_TEXT_NODE
}

public protocol XmlDomNode {
    
    var name: String {
        get
    }
    
    var type: XmlDomNodeType {
        get
    }
    
    var attributes: [XmlDomAttribute] {
        get
    }
    
    var children: [XmlDomNode] {
        get
    }
    
    subscript(name: String) -> XmlDomElement? {
        get
    }
}

internal func createNode(node: xmlNodePtr) throws -> XmlDomNode {
    
    guard let type = XmlDomNodeType(rawValue: node.pointee.type.rawValue) else {
        throw XmlParserError.unknownError(msg: "type null")
    }
    
    switch type {
    case .element :
        return try XmlDomElement(node: node)
    case .text :
        return try XmlDomTextNode(node: node)
    //default:
    //    throw XmlParserError.unknownError(msg: "Type not implemented : \(node.pointee.type)")
    }
}

public class GenericXmlDomNode {
    
    internal var node : xmlNodePtr
    
    public lazy var children : [XmlDomNode] = {
        var nodes = [XmlDomNode]()
        
        var childPtr = self.node.pointee.children
        while (childPtr != nil) {
            
            if let node = try? createNode(node: childPtr!) {
                nodes.append(node)
            }
            
            childPtr = childPtr!.pointee.next
        }
        
        return nodes
    } ()
    
    
    public lazy var attributes: [XmlDomAttribute] = {
        var attributes = [XmlDomAttribute]()
        
        var attrPtr = self.node.pointee.properties
        while (attrPtr != nil) {
            
            attributes.append(XmlDomAttribute(attr: attrPtr!))
            
            attrPtr = attrPtr!.pointee.next
        }
        
        return attributes
    } ()
    
    lazy private var dico: Dictionary<String, XmlDomElement> = {
        var dico = Dictionary<String, XmlDomElement>()
        
        for child in self.children {
            if let element = child as? XmlDomElement {
                dico[element.name] = element
            }
        }
        
        return dico
    } ()
    
    public subscript(name: String) -> XmlDomElement? {
        get {
            return dico[name]
        }
    }
    
    init(node: xmlNodePtr) throws {
        self.node = node
    }
}
