//
//  ViewController.m
//  GPS_Test
//
//  Created by lsh726 on 16/1/21.
//  Copyright © 2016年 liusonghong. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate,NSUserActivityDelegate>
{
    CLLocationManager *_manager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self readAndWritePlist];
//    [self searchApp];

//    [self startlocation];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)readAndWritePlist {

    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filepath = [path stringByAppendingString:@"cumstom.plist"];
    NSDictionary *dic = @{@"name":@"lsh",
                         @"age" :@"27",
                         @"phone":@"18949524365"};
    [dic writeToFile:filepath atomically:YES];

    NSString *customPath = [[NSBundle mainBundle] pathForResource:@"CustomPlist" ofType:@"plist"];
    NSDictionary *customDic = [[NSDictionary alloc]initWithContentsOfFile:customPath];//自定义
     NSDictionary *dic1 = [[NSBundle mainBundle] infoDictionary];//系统

    
//    NSString *pathCustomOfPlist = [[NSBundle mainBundle]pathForResource:@"CustomPlist" ofType:@"plist"];
//    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:pathCustomOfPlist];
}

- (void)searchApp {
    NSUserActivity *activity = [[NSUserActivity alloc]initWithActivityType:[[[NSBundle mainBundle]infoDictionary] objectForKey:@"NSUserActivityTypes"]];
    activity.title = @"IVY网络摄像头";
    NSLog(@"%@",activity.activityType);
    NSLog(@"%@",[[NSBundle mainBundle] localizedInfoDictionary]);
    activity.delegate = self;
    activity.eligibleForSearch = YES;
    activity.expirationDate = [NSDate date];
    [activity becomeCurrent];
}

- (void)userActivity:(NSUserActivity *)userActivity didReceiveInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {


}

- (void)startlocation {
    _manager = [[CLLocationManager alloc]init];
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = 100000;
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"设备开启定位");
    }
   NSLog(@"%d",[CLLocationManager authorizationStatus]);
    if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
//        [manger requestAlwaysAuthorization];
    }
    if ([_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_manager requestWhenInUseAuthorization];
    }
    [_manager startUpdatingLocation];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 45, 45)];
    [btn setTitle:@"开始定位" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnaction {



}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    CLLocation *location = [locations lastObject];
    NSLog(@"经度 == %f",location.horizontalAccuracy);
    NSLog(@"纬度 == %f",location.verticalAccuracy);
    NSLog(@"%@",locations);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位错误 == %@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
