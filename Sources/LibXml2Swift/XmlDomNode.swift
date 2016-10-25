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
    
    subscript(name: String) -> XmlDomAttribute? {
        get
    }
    
    var children: [XmlDomNode] {
        get
    }
    
    func children(name: String) -> [XmlDomElement]
    func child(name: String) -> XmlDomElement?
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
    
    // Libxml2 pointer
    internal var node : xmlNodePtr
    
    // --- Attributes ---
    
    /// All attributes load lazily
    public lazy var attributes: [XmlDomAttribute] = {
        var attributes = [XmlDomAttribute]()
        
        var attrPtr = self.node.pointee.properties
        while (attrPtr != nil) {
            
            attributes.append(XmlDomAttribute(attr: attrPtr!))
            
            attrPtr = attrPtr!.pointee.next
        }
        
        return attributes
    } ()
    
    /// Load dico of attributes lazily
    private lazy var attributesDico: Dictionary<String, XmlDomAttribute> = {
        var attrs = Dictionary<String, XmlDomAttribute>()
        for attr in self.attributes {
            attrs[attr.name] = attr
        }
        return attrs
    } ()
    
    
    /// Find attribute
    public subscript(name: String) -> XmlDomAttribute? {
        get {
            return attributesDico[name]
        }
    }
    
    // --- Children ---
    
    /// All children loaded lazily
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
    
    /// Load dico of elements lazily
    lazy private var elementDico: Dictionary<String, [XmlDomElement]> = {
        var dico = Dictionary<String, [XmlDomElement]>()
        
        for child in self.children {
            if let element = child as? XmlDomElement {
                
                var elements = dico[element.name]
                if (elements == nil) {
                    elements = [XmlDomElement]()
                    dico[element.name] = elements
                }
                
                elements!.append(element)
            }
        }
        
        return dico
    } ()
    
    /// Find elements by name
    public func children(name: String) -> [XmlDomElement] {
        if let elements =  elementDico[name] {
            return elements
        } else {
            return [XmlDomElement]()
        }
    }
    
    /// Find element
    public func child(name: String) -> XmlDomElement? {
        if let elements = elementDico[name] {
            return elements[0]
        } else {
            return nil
        }
    }
    
    init(node: xmlNodePtr) throws {
        self.node = node
    }
}
