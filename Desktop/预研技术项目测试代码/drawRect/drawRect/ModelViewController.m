//
//  ModelViewController.m
//  drawRect
//
//  Created by liusonghong on 15/6/18.
//  Copyright (c) 2015年 liusonghong. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController ()
{
    NSTimer *_timer;
}
@end


@implementation ModelViewController

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
        [self.arr addObject:@"1"];
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
//        NSString *str = @"1";
//    NSArray *arr = @[str];
//    
////    NSString *str2 = [str mutableCopy];
////    NSLog(@"%p",str2);
//    NSLog(@"arr==%p",arr);
//    NSLog(@"arr[0]==%p",arr[0]);
//    NSLog(@"str ==%p",str);
//   
//    NSMutableArray *array = [arr mutableCopy];
//    NSLog(@"array ==%p",array);
//    NSLog(@"array[0]==%p",array[0]);
    
    
}
-(void)scanLineMove
{
    
    NSLog(@"执行？");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
