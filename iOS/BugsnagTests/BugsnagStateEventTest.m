//
//  BugsnagStateEventTest.m
//  Tests
//
//  Created by Jamie Lynch on 18/03/2020.
//  Copyright © 2020 Bugsnag. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Bugsnag.h"
#import "BugsnagConfiguration.h"
#import "BugsnagTestConstants.h"
#import "BugsnagStateEvent.h"

@interface BugsnagStateEventTest : XCTestCase
@property BugsnagConfiguration *config;
@property BugsnagStateEvent *event;
@end

@interface BugsnagConfiguration()
- (void)registerStateObserverWithBlock:(void (^_Nonnull)(BugsnagStateEvent *_Nonnull))event;
@end

@implementation BugsnagStateEventTest

- (void)setUp {
    self.config = [[BugsnagConfiguration alloc] initWithApiKey:DUMMY_APIKEY_32CHAR_1 error:nil];
    [self.config registerStateObserverWithBlock:^(BugsnagStateEvent *event) {
        self.event = event;
    }];
}

- (void)testUserUpdate {
    [self.config setUser:@"123" withName:@"Jamie" andEmail:@"test@example.com"];

    BugsnagStateEvent* obj = self.event;
    XCTAssertEqualObjects(@"UserUpdate", obj.name);

    NSDictionary *dict = obj.data;
    XCTAssertEqualObjects(@"123", dict[@"id"]);
    XCTAssertEqualObjects(@"Jamie", dict[@"name"]);
    XCTAssertEqualObjects(@"test@example.com", dict[@"email"]);
}

- (void)testContextUpdate {
    [self.config setContext:@"Foo"];
    BugsnagStateEvent* obj = self.event;
    XCTAssertEqualObjects(@"ContextUpdate", obj.name);
    XCTAssertEqualObjects(@"Foo", obj.data);
}

- (void)testMetadataUpdate {
    [self.config.metadata addAttribute:@"Foo" withValue:@"Bar" toTabWithName:@"test"];
    BugsnagStateEvent* obj = self.event;
    XCTAssertEqualObjects(@"MetadataUpdate", obj.name);
    XCTAssertEqualObjects(@{
        @"test" : @{ @"Foo" : @"Bar" }
    }, obj.data);
}

@end
