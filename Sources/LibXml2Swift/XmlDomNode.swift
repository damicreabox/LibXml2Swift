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
}

internal func createNode(node: xmlNodePtr) throws -> XmlDomNode {
    
    guard let type = XmlDomNodeType(rawValue: node.pointee.type.rawValue) else {
        throw XmlParserError.unknownError(msg: "type null")
    }
    
    switch type {
    case .element :
        return try XmlDomElement(node: node)
    default:
        throw XmlParserError.unknownError(msg: "Type not implemented : \(node.pointee.type)")
    }
}

public class GenericXmlDomNode {
    
    internal var node : xmlNodePtr
    
    lazy public var name : String = {
        return String(cString: self.node.pointee.name)
    } ()
    
    init(node: xmlNodePtr) throws {
        self.node = node
    }
}
