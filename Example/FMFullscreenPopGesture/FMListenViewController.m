//
//  FMViewController.m
//  FullscreenPopGesture
//
//  Created by fengming on 04/06/2023.
//  Copyright (c) 2023 fengming. All rights reserved.
//

#import "FMListenViewController.h"
@import FMFullscreenPopGesture;

@interface FMListenViewController ()

@end

@implementation FMListenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.fd_interactivePopDisabled = YES;
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 20;
}

- (void)fd_popDisabledStatus
{
    NSLog(@"Disabled scroll left back");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
