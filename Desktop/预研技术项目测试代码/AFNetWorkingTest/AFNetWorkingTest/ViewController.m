//
//  ViewController.m
//  AFNetWorkingTest
//
//  Created by liusonghong on 15/7/1.
//  Copyright (c) 2015年 liusonghong. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
@interface ViewController ()
{
    AFHTTPRequestOperationManager *_manager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[AFHTTPRequestOperationManager alloc]init];
    _manager.requestSerializer.allowsCellularAccess = YES;//允许蜂窝移动网
    _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
