//
//  ViewController.m
//  experiments-objective-c
//
//  Created by Andrew Ashurow on 09.09.16.
//  Copyright © 2016 Andrew Ashurow. All rights reserved.
//

#import "ViewController.h"
#import "UIViewExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)setupViewController {
    
    
    [self.view makeItBlack];
    NSLog(@"Setup overrided");
}

@end
