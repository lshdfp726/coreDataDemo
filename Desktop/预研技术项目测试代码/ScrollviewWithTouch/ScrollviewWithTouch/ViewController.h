//
//  ViewController.h
//  ScrollviewWithTouch
//
//  Created by 徐远翔 on 15/8/25.
//  Copyright (c) 2015年 MiDaiCaiFu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (nonatomic,assign)void(^block)(NSString *str);

@property (nonatomic,assign)void(^BlockTest)(NSString *str);

@end

