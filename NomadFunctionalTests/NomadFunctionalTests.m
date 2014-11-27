//
//  NomadFunctionalTests.m
//  NomadFunctionalTests
//
//  Created by Jeroen Leenarts on 27-11-14.
//  Copyright (c) 2014 Nomad. All rights reserved.
//

#import <KIF/KIF.h>

@interface NomadFunctionalTests : KIFTestCase

@end

@implementation NomadFunctionalTests

- (void)beforeEach
{
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)afterEach
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    
    [tester enterText:@"New York" intoViewWithAccessibilityLabel:@"Search or Address"];
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

@end
