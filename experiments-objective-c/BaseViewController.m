//
//  BaseViewController.m
//  experiments-objective-c
//
//  Created by Andrew Ashurow on 09.09.16.
//  Copyright © 2016 Andrew Ashurow. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@end


@implementation BaseViewController : UIViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupViewController];
    [self refreshViewController];
}

- (void)setupViewController {
    NSLog(@"Setup");
}

- (void)refreshViewController {
    NSLog(@"Refresh");
}



@end
