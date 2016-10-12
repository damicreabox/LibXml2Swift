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
    
    lazy public var name : String = {
        return String(cString: self.node.pointee.name)
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
