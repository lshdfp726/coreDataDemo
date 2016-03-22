//
//  ViewController.m
//  drawRect
//
//  Created by liusonghong on 15/5/5.
//  Copyright (c) 2015年 liusonghong. All rights reserved.
//

#import "ViewController.h"
#import "ModelViewController.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *SwitchButton;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
//  
    NSDictionary *dic = [NSDictionary dictionary];
    dic = @{@"key":@"1",@"key2":@"2"};
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"123"];
    NSLog(@"%@",dic);
     NSString *str = @"完美dota2";
      NSMutableAttributedString *attrubtString = [[NSMutableAttributedString alloc]initWithString:str];
//    NSDictionary *attruDic =  [attrubtString attributesAtIndex:2.0 longestEffectiveRange:NSMakeRange(2, 3) inRange:NSMakeRange(2, 5)];;

//    [attrubtString setAttributes:attruDic range:NSMakeRange(2, str.length-2)];
   
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    label.attributedText = attrubtString;
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 100, 100);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    UIImage *img = [UIImage imageNamed:@"on.png"];
//         NSData *data = UIImagePNGRepresentation(img);
//    
//    NSDictionary *dic = @{ @"access_token" : @"6852dcd47239434ea5083911142d4a59"};
//    [manager POST:@"http://115.29.45.178:8088/upload/uploadAvatar.do" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar" mimeType:@"image/png"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *codeStr = [responseObject objectForKey:@"result_code"];
//        //        NSInteger code = [codeStr integerValue];
//        NSLog(@"%@",[responseObject valueForKey:@"result_msg"]);
//        
//        NSLog(@"上传成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"上传失败");
//    }];

}
- (IBAction)btnAction:(UISwitch *)sender {
    NSLog(@"进来了");
}

-(void)jump
{
    ModelViewController *model = [[ModelViewController alloc]init];
    [self presentViewController:model animated:YES completion:^{
        NSLog(@"%p",self);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
