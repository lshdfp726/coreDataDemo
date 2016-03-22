//
//  UIScrollView+TouchEvent.h
//  SwipeGestureDemo
//
//  Created by YuanxiangXU on 15/1/21.
//  Copyright (c) 2015年 YuanxiangXU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIScrollView (extension)

-(void)text;

@end

@interface UIScrollView (TouchEvent)

@property (nonatomic, assign) void(^fetchPoint)(CGPoint);

@end
