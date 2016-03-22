//
//  mapView.m
//  GPS_Test
//
//  Created by lsh726 on 16/1/21.
//  Copyright © 2016年 liusonghong. All rights reserved.
//

#import "mapView.h"
#import <MapKit/MapKit.h>


@interface mapView()<MKMapViewDelegate>

@end


@implementation mapView


- (instancetype)initWithFrame:(CGRect)frame {
      self =  [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {

    MKMapView *mapView = [[MKMapView alloc]initWithFrame:self.frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
