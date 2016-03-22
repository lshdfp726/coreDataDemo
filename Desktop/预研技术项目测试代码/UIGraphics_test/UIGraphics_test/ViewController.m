//
//  ViewController.m
//  UIGraphics_test
//
//  Created by liusonghong on 15/6/24.
//  Copyright (c) 2015年 liusonghong. All rights reserved.
//

#import "ViewController.h"
#import "grap.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    grap *Vi = [[grap alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
 

//    Vi.backgroundColor = [UIColor blueColor];
    [self.view addSubview:Vi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
