//
//  UIScrollView+TouchEvent.m
//  SwipeGestureDemo
//
//  Created by YuanxiangXU on 15/1/21.
//  Copyright (c) 2015年 YuanxiangXU. All rights reserved.
//

#import "UIScrollView+TouchEvent.h"
#import <objc/runtime.h>


@implementation UIScrollView (TouchEvent)

-(void)text{
    [self hello];
}

-(void)hello{

    NSLog(@"hell world");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    
    NSLog(@"touch Begin!");
    
    CGPoint points = [[touches anyObject] locationInView:self];
    if (self.fetchPoint) {//使用block块
        self.fetchPoint(points);
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"touch move");
    
}

//set方法
- (void)setFetchPoint:(void (^)(CGPoint))fetchPoint
{
    //通过runtime 把block方法传到下面去，相当于定义block块
    objc_setAssociatedObject(self, @selector(fetchPoint), fetchPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//get方法
- (void (^)(CGPoint))fetchPoint
{
    return objc_getAssociatedObject(self, @selector(fetchPoint));
}

@end
