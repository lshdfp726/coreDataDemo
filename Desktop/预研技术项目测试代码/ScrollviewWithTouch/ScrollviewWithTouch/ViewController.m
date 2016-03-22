//
//  ViewController.m
//  ScrollviewWithTouch
//
//  Created by 徐远翔 on 15/8/25.
//  Copyright (c) 2015年 MiDaiCaiFu. All rights reserved.
//

#import "ViewController.h"

#import <UIKit/UIKit.h>

#import "UIScrollView+TouchEvent.h"

#import <objc/runtime.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tbView.dataSource = self;
    tbView.delegate = self;
    [self.view addSubview:tbView];
    
    [tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    tbView.rowHeight = 80;

    [tbView text];
//    [tbView setFetchPoint:^(CGPoint point) {
//        
////        NSLog(@"这里可以回调哦！ 点击了 %@ 这个点哦！",NSStringFromCGPoint(point));
//
//    }];

    tbView.fetchPoint = ^(CGPoint point){
        
        NSLog(@"这里可以回调哦！ 点击了 %@ 这个点哦！",NSStringFromCGPoint(point));

    };


    self.block = ^(NSString *str){

    };

    self.BlockTest = ^(NSString *str){

        NSLog(@"get方法进来了");

    };


    if (self.BlockTest) {
        self.BlockTest(@"get方法");
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld行",indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第%ld行被选中了！",indexPath.row);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setBlock:(void (^)(NSString *))block
{
    objc_setAssociatedObject(self,@selector(block),block,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(NSString *str))block{

    return  objc_getAssociatedObject(self, @selector(block));
}


@end
