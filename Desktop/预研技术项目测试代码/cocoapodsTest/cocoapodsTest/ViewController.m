//
//  ViewController.m
//  cocoapodsTest
//
//  Created by lsh726 on 16/2/18.
//  Copyright © 2016年 liusonghong. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <UAProgressView.h>
#import <Masonry.h>
@interface ViewController (){
    UAProgressView *_progressView;
    UILabel *_textLabel;
    NSString *_documentPath;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //上传过程
    [self AFNetWorkingTest];
//    [self Manory];
    //上传测试2016-3-21
    //TEST

}

- (void)Manory {
#if 1
    //第三方Manory方法
    UIView *leftView = [[UIView alloc]init];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    leftView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftView];

    UIView *rightView = [[UIView alloc]init];
    rightView.translatesAutoresizingMaskIntoConstraints = NO;
    rightView.backgroundColor = [UIColor redColor];
    [self.view addSubview:rightView];

    //代码添加约束
    UIEdgeInsets pad = UIEdgeInsetsMake(64, 20, 200,200);
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(pad.left);
        make.top.equalTo(self.view.mas_top).with.offset(pad.top);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];

    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).with.offset(20);
        make.top.equalTo(leftView.mas_top);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.bottom.equalTo(leftView.mas_bottom);
    }];


#else
    //系统的方法，繁琐
    UIView *view1 = [[UIView alloc]init];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view1];

    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addConstraints:@[
                                //view1 constraints
                                [NSLayoutConstraint constraintWithItem:view1
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:padding.top],

                                [NSLayoutConstraint constraintWithItem:view1
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:padding.left],

                                [NSLayoutConstraint constraintWithItem:view1
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:-padding.bottom],
                                
                                [NSLayoutConstraint constraintWithItem:view1
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:-padding.right]]];
#endif
}

- (void)AFNetWorkingTest {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"上传" forState:UIControlStateNormal];
    //    btn.font = [UIFont systemFontOfSize:12.0];
    [btn setFrame:CGRectMake(100, 100, 45, 45)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(downloadMessage) forControlEvents:UIControlEventTouchUpInside];

    _progressView = [[UAProgressView alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 100, 100)];
    [self.view addSubview:_progressView];
    _progressView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _textLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16.0];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = _progressView.tintColor;
    _textLabel.backgroundColor = [UIColor clearColor];
    _progressView.centralView = _textLabel;
    _progressView.borderWidth = 2.0;
    _progressView.lineWidth = 2.0;
    _progressView.fillOnTouch = YES;
    //上传的资源存放，自己可以存
    UIImage *image = [UIImage imageNamed:@"IMG_2187.jpg"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _documentPath = [path stringByAppendingString:@"/image.jpg"];
    BOOL result = [UIImageJPEGRepresentation(image, 0.5) writeToFile:_documentPath  atomically:YES];
    if (result) {
        NSLog(@"保存成功");
    }else {
        NSLog(@"保存失败");
    }

}
- (void)downloadMessage {
#if 0
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSURL *url = [NSURL URLWithString:@"http://example.com/download.zip"];//http://box2.9ku.com/download.php?from=9ku
    //http://example.com/download.zip
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"file download to %@",filePath);
    }];
    [downloadTask resume];
#else
     //@"http://example.com/upload" 服务器地址可以自己找。或者拿这个来测试，本demo主要测试上传过程的进度。结果传不上去应该是服务器地址有问题
     NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         [formData appendPartWithFileURL:[NSURL fileURLWithPath:_documentPath] name:@"IMG_2187" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
     } error:nil];
     AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadtask;
    uploadtask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [_progressView setProgress:uploadProgress.fractionCompleted];
                          _textLabel.text = [NSString stringWithFormat:@"%.0f%%",uploadProgress.fractionCompleted * 100];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          _textLabel.text = @"上传成功";

                      } else {
                          NSLog(@"%@ %@", response, responseObject);

                      }
                  }];
    [uploadtask resume];

//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
//    manager.requestSerializer.timeoutInterval = 10.0;
//    NSString *url = @"www.baidu.com";
//    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//       
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];

#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
