//
//  SOCTableViewControllerTests.m
//  StackOverflowChallenge
//
//  Created by Cafex-Development on 01/03/16.
//  Copyright © 2016 Cafex-Development. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SOCTableViewController.h"
#import "SOCApiRequestManager.h"
#import "Constants.h"

@interface SOCTableViewControllerTests : XCTestCase
@property (strong, nonatomic) SOCTableViewController *socVCToTest;
@end

@interface SOCTableViewController(test)
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SOCTableViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _socVCToTest = (SOCTableViewController*)[storyboard instantiateInitialViewController];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testfetchUsersFromServer
{
    // asynchronous block callback was called expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTTP request"];
    SOCApiRequestManager *apiManager = [[SOCApiRequestManager alloc]init];
    [apiManager fetchUsersWithUrl:kUsersEndPoint completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
    /* wait for the asynchronous block callback was called expectation to be fulfilled
     fail after 5 seconds */
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
}

-(void)testHasTableViewPropertySetAfterLoading
{
    // when
    // 2
    XCTAssertNil(_socVCToTest.tableView, "Before loading the table view should be nil");
    
    // 3
    UIView *view = _socVCToTest.view;
    XCTAssertTrue(_socVCToTest.tableView != nil, @"TableView should be set");
}
@end
