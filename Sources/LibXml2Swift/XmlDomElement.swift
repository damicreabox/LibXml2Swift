//
//  XmlDomElement.swift
//  LibXml2Swift
//
//  Created by Dami on 12/10/2016.
//
//

import Foundation
import CLibxml

public class XmlDomElement : GenericXmlDomNode, XmlDomNode {
    
    public let type = XmlDomNodeType.element
    
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
    
    override init(node: xmlNodePtr) throws {
        
        // Find node type
        let nodeType = XmlDomNodeType(rawValue: node.pointee.type.rawValue)
        guard nodeType == XmlDomNodeType.element else {
            throw XmlParserError.invalidType(type: .element, real: nodeType)
        }
        
        try super.init(node: node)
    }
}
