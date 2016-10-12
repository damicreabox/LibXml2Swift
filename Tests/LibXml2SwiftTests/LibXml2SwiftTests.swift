import XCTest
@testable import LibXml2Swift

import Foundation
import CLibxml

func creatNodeName(node: XmlDomNode) -> String {
    
    var first = true
    
    var str = node.name + "("
    
    for attr in node.attributes {
        
        if (first) {
            first = false
        } else {
            str += ", "
        }
        
        str += attr.name + "='" + attr.value + "'"
    }
    
    str += ")"
    
    return str
}

func print_element_names(node: XmlDomNode, prefix: String = "") {
 
    if (node.type == .element) {
        print("\(prefix)\(creatNodeName(node: node))")
        for child in node.children {
            print_element_names(node: child, prefix: prefix + "\t")
        }
    } else {
        if (!node.name.isEmpty) {
            print(prefix + " -> " + node.name)
        }
    }
    
}

class LibXml2SwiftTests: XCTestCase {
    
    func testExample() {
        
        do {
            
            // XML Url
            let url = URL(fileURLWithPath: "Files/MainMenu.xib")
            
            // Open documents
            let document = try XmlDomReader.read(atPath: url)
            
            // Recherche de l'eleemnt racine
            let rootElement = try document.rootElement()
            
            // Print root element
            print_element_names(node: rootElement)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
