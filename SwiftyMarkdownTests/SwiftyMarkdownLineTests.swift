//
//  SwiftyMarkdownTests.swift
//  SwiftyMarkdownTests
//
//  Created by Simon Fairbairn on 05/03/2016.
//  Copyright © 2016 Voyage Travel Apps. All rights reserved.
//

import XCTest
@testable import SwiftyMarkdown

struct StringTest {
	let input : String
	let expectedOutput : String
	var acutalOutput : String = ""
}

struct TokenTest {
	let input : String
	let output : String
	let tokens : [Token]
}

class SwiftyMarkdownTests: XCTestCase {
    
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testThatOctothorpeHeadersAreHandledCorrectly() {
		
		let heading1 = StringTest(input: "# Heading 1", expectedOutput: "Heading 1")
		var smd = SwiftyMarkdown(string:heading1.input )
		XCTAssertEqual(smd.attributedString().string, heading1.expectedOutput)
		
		let heading2 = StringTest(input: "## Heading 2", expectedOutput: "Heading 2")
		smd = SwiftyMarkdown(string:heading2.input )
		XCTAssertEqual(smd.attributedString().string, heading2.expectedOutput)
		
		let heading3 = StringTest(input: "### #Heading #3", expectedOutput: "#Heading #3")
		smd = SwiftyMarkdown(string:heading3.input )
		XCTAssertEqual(smd.attributedString().string, heading3.expectedOutput)
		
		let heading4 = StringTest(input: "  #### #Heading 4 ####", expectedOutput: "#Heading 4")
		smd = SwiftyMarkdown(string:heading4.input )
		XCTAssertEqual(smd.attributedString().string, heading4.expectedOutput)
		
		let heading5 = StringTest(input: " ##### Heading 5 ####   ", expectedOutput: "Heading 5 ####")
		smd = SwiftyMarkdown(string:heading5.input )
		XCTAssertEqual(smd.attributedString().string, heading5.expectedOutput)
		
		let heading6 = StringTest(input: " ##### Heading 5 #### More ", expectedOutput: "Heading 5 #### More")
		smd = SwiftyMarkdown(string:heading6.input )
		XCTAssertEqual(smd.attributedString().string, heading6.expectedOutput)
		
		let heading7 = StringTest(input: "# **Bold Header 1** ", expectedOutput: "Bold Header 1")
		smd = SwiftyMarkdown(string:heading7.input )
		XCTAssertEqual(smd.attributedString().string, heading7.expectedOutput)
		
		let heading8 = StringTest(input: "## Header 2 _With Italics_", expectedOutput: "Header 2 With Italics")
		smd = SwiftyMarkdown(string:heading8.input )
		XCTAssertEqual(smd.attributedString().string, heading8.expectedOutput)
		
		let heading9 = StringTest(input: "    # Heading 1", expectedOutput: "# Heading 1")
		smd = SwiftyMarkdown(string:heading9.input )
		XCTAssertEqual(smd.attributedString().string, heading9.expectedOutput)

		let allHeaders = [heading1, heading2, heading3, heading4, heading5, heading6, heading7, heading8, heading9]
		smd = SwiftyMarkdown(string: allHeaders.map({ $0.input }).joined(separator: "\n"))
		XCTAssertEqual(smd.attributedString().string, allHeaders.map({ $0.expectedOutput}).joined(separator: "\n"))
		
		let headerString = StringTest(input: "# Header 1\n## Header 2 ##\n### Header 3 ### \n#### Header 4#### \n##### Header 5\n###### Header 6", expectedOutput: "Header 1\nHeader 2\nHeader 3\nHeader 4\nHeader 5\nHeader 6")
		smd = SwiftyMarkdown(string: headerString.input)
		XCTAssertEqual(smd.attributedString().string, headerString.expectedOutput)
		
		let headerStringWithBold = StringTest(input: "# **Bold Header 1**", expectedOutput: "Bold Header 1")
		smd = SwiftyMarkdown(string: headerStringWithBold.input)
		XCTAssertEqual(smd.attributedString().string, headerStringWithBold.expectedOutput )
		
		let headerStringWithItalic = StringTest(input: "## Header 2 _With Italics_", expectedOutput: "Header 2 With Italics")
		smd = SwiftyMarkdown(string: headerStringWithItalic.input)
		XCTAssertEqual(smd.attributedString().string, headerStringWithItalic.expectedOutput)
		
	}

	
	func testThatUndelinedHeadersAreHandledCorrectly() {

		let h1String = StringTest(input: "Header 1\n===\nSome following text", expectedOutput: "Header 1\nSome following text")
		var md = SwiftyMarkdown(string: h1String.input)
		XCTAssertEqual(md.attributedString().string, h1String.expectedOutput)
		
		let h2String = StringTest(input: "Header 2\n---\nSome following text", expectedOutput: "Header 2\nSome following text")
		md = SwiftyMarkdown(string: h2String.input)
		XCTAssertEqual(md.attributedString().string, h2String.expectedOutput)
		
		let h1StringWithBold = StringTest(input: "Header 1 **With Bold**\n===\nSome following text", expectedOutput: "Header 1 With Bold\nSome following text")
		md = SwiftyMarkdown(string: h1StringWithBold.input)
		XCTAssertEqual(md.attributedString().string, h1StringWithBold.expectedOutput)
		
		let h2StringWithItalic = StringTest(input: "Header 2 _With Italic_\n---\nSome following text", expectedOutput: "Header 2 With Italic\nSome following text")
		md = SwiftyMarkdown(string: h2StringWithItalic.input)
		XCTAssertEqual(md.attributedString().string, h2StringWithItalic.expectedOutput)
		
		let h2StringWithCode = StringTest(input: "Header 2 `With Code`\n---\nSome following text", expectedOutput: "Header 2 With Code\nSome following text")
		md = SwiftyMarkdown(string: h2StringWithCode.input)
		XCTAssertEqual(md.attributedString().string, h2StringWithCode.expectedOutput)
	}
	
	
	
    /*
        The reason for this test is because the list of items dropped every other item in bullet lists marked with "-"
        The faulty result was: "A cool title\n \n- Här har vi svenska ÅÄÖåäö tecken\n \nA Link"
        As you can see, "- Point number one" and "- Point number two" are mysteriously missing.
        It incorrectly identified rows as `Alt-H2` 
     */
    func offtestInternationalCharactersInList() {
        
        let expected = "A cool title\n\n- Point number one\n- Här har vi svenska ÅÄÖåäö tecken\n- Point number two\n \nA Link"
        let input = "# A cool title\n\n- Point number one\n- Här har vi svenska ÅÄÖåäö tecken\n- Point number two\n\n[A Link](http://dooer.com)"
        let output = SwiftyMarkdown(string: input).attributedString().string

        XCTAssertEqual(output, expected)
        
    }
	
	func testReportedCrashingStrings() {
		let text = "[**\\!bang**](https://duckduckgo.com/bang) "
		let expected = "\\!bang"
		let output = SwiftyMarkdown(string: text).attributedString().string
		XCTAssertEqual(output, expected)
	}
	
}
