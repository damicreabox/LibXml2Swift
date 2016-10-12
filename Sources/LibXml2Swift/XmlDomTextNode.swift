//
//  XmlDomTextNode.swift
//  LibXml2Swift
//
//  Created by Dami on 12/10/2016.
//
//

import Foundation

import CLibxml

public class XmlDomTextNode : GenericXmlDomNode, XmlDomNode {
    
    public let type = XmlDomNodeType.text
    
    lazy public var name : String = {
        let str = String(cString: self.node.pointee.content)
        if (str.trimmingCharacters(in: [" ", "\n"]) == "") {
            return "";
        } else {
            return str
        }
    } ()
    
    lazy public var content : String = {
        return String(cString: self.node.pointee.content)
    } ()
    
    
    override init(node: xmlNodePtr) throws {
        
        // Find node type
        let nodeType = XmlDomNodeType(rawValue: node.pointee.type.rawValue)
        guard nodeType == XmlDomNodeType.text else {
            throw XmlParserError.invalidType(type: .text, real: nodeType)
        }
        
        try super.init(node: node)
    }
}
