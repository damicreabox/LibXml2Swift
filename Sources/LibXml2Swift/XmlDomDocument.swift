//
//  XmlDomDocument.swift
//  LibXml2Swift
//
//  Created by Dami on 12/10/2016.
//
//

import Foundation
import CLibxml

public class XmlDomDocument {
    
    internal let doc : xmlDocPtr
    
    init(pointer: xmlDocPtr) {
        self.doc = pointer
    }
    
    deinit {
        // Close document
        xmlFreeDoc(doc)
    }
    
    public func rootElement() throws -> XmlDomElement {
        
        // Find root element
        let root_element = xmlDocGetRootElement(doc)
        guard root_element != nil else {
            throw XmlParserError.noNode(msg: "root")
        }
        
        return try XmlDomElement(node: root_element!)
    }
}
