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
    /// 返回控制 NO: 不允许返回，YES：允许返回
    __weak typeof(self) weakSelf = self;
    self.shouldBeginBlock = ^BOOL{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.isCheckChanged) {
            return !(strongSelf.isCheckChanged);
        };
        return YES;
    };
}

- (BOOL)isCheckChanged
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
