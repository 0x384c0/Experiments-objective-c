//
//  ViewController.m
//  experiments-objective-c
//
//  Created by Andrew Ashurow on 09.09.16.
//  Copyright © 2016 Andrew Ashurow. All rights reserved.
//

#import "ViewController.h"
#import "experiments_objective_c-swift.h"
#import "UIViewExtension.h"
//#import "View-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewForTesting;

@end

@implementation ViewController

- (void)setupViewController {
    [_viewForTesting makeItBlack];
    [_viewForTesting rotateBy180:1];
    NSLog(@"Setup overrided");
    
    NSString *string;
    NSLog(@"isNotBlank for nil: %d",string.isNotBlank);
    string = @"";
    NSLog(@"isNotBlank for blank: %d",string.isNotBlank);
    string = @"123";
    NSLog(@"isNotBlank for non blank: %d",string.isNotBlank);
    
}

@end