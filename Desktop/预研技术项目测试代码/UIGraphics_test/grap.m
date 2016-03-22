//
//  grap.m
//  UIGraphics_test
//
//  Created by liusonghong on 15/6/26.
//  Copyright (c) 2015年 liusonghong. All rights reserved.
//

#import "grap.h"

@implementation grap

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    context = UIGraphicsGetCurrentContext();
    //设置背景颜色
    CGContextTranslateCTM(context, 0,0);
    CGContextRotateCTM (context, 0.1);
//    CGContextScaleCTM(context, 1.0f, -1.0f);
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context,320);
    CGContextSetRGBStrokeColor(context, 250.0/255, 250.0/255, 210.0/255, 1.0);
    CGContextStrokeRect(context, CGRectMake(0, 0, 320, 640));
 
//    //画一个正方形
//    CGContextSetRGBFillColor(context, 0, 1.0, 0, 0.5);
//    CGContextFillRect(context, CGRectMake(10,10, 50, 50));
//    CGContextStrokePath(context);
//    
//    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0);
//    CGContextSetLineWidth(context, 2.0);
//    CGContextAddRect(context, CGRectMake(10,10, 50, 50));//只画一个外围线框
//    CGContextStrokePath(context);//开始绘制图片

    //画线
    CGSize ret = self.frame.size;
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);//线填充颜色
    CGContextSetLineWidth(context, 2.0);//线宽
    CGPoint aPoints[10];
    aPoints[0] =CGPointMake(ret.width/2, 0);
    aPoints[1] =CGPointMake(ret.width*3/4,ret.height/4);
    aPoints[2] =CGPointMake(ret.width,ret.height/2);
    aPoints[3] =CGPointMake(ret.width*3/4, ret.height*3/4);
    aPoints[4] =CGPointMake(ret.width, ret.height);
    aPoints[5] =CGPointMake(0, ret.height);
    aPoints[6] =CGPointMake(ret.width/4, ret.height*3/4);
    aPoints[7] =CGPointMake(0, ret.height/2);
    aPoints[8] =CGPointMake(ret.width/4, ret.height/4);
    aPoints[9] =CGPointMake(ret.width/2, 0);
    CGContextAddLines(context, aPoints, 10);
    CGContextDrawPath(context, kCGPathStroke); //开始画线

}

@end




