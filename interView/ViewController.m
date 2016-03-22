//
//  ViewController.m
//  interView
//
//  Created by lsh726 on 16/2/22.
//  Copyright © 2016年 liusonghong. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataModel.h"
#import <Masonry.h>

typedef void(^TextField)(NSString *);

@interface ViewController ()<UITextFieldDelegate>
{
    NSMutableDictionary *_informationDic;
    Company *_company;
    CGRect _rect;
}

@property (nonatomic, strong) TextField getInformationBlock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _rect = self.view.frame;
     _company = [[CoreDataModel shareCoreDataModel]update];
     _informationDic = [NSMutableDictionary dictionary];
     [self createUI];

}
- (void)createUI{

    UITextField *companyTextField = [[UITextField alloc]init];
    companyTextField.translatesAutoresizingMaskIntoConstraints = NO;
    companyTextField.placeholder = @"请输入公司名称";
    companyTextField.tag = 100;
    companyTextField.font = [UIFont systemFontOfSize:12.0];
    companyTextField.text = _company.name;
    companyTextField.delegate = self;
    [_informationDic setValue:companyTextField.text forKey:@"name"];
    [self.view addSubview:companyTextField];

    UITextField *addressTextField = [[UITextField alloc]init];
    addressTextField.translatesAutoresizingMaskIntoConstraints = NO;
    addressTextField.placeholder = @"请输入公司地址";
    addressTextField.tag = 101;
    addressTextField.delegate = self;
    addressTextField.text     = _company.address;
     [_informationDic setValue:addressTextField.text forKey:@"address"];
    addressTextField.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:addressTextField];

    UITextField *timerTextField = [[UITextField alloc]init];
    timerTextField.translatesAutoresizingMaskIntoConstraints = NO;
    timerTextField.font = [UIFont systemFontOfSize:12.0];
    timerTextField.tag = 102;
    timerTextField.delegate = self;
    timerTextField.text = _company.time;
     [_informationDic setValue:timerTextField.text forKey:@"time"];
    timerTextField.placeholder  = @"请输入面试时间";
    [self.view addSubview:timerTextField];

     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    [companyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.top.equalTo(self.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/5));
    }];

    [addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyTextField);
        make.top.equalTo(companyTextField.mas_bottom).with.offset(20);
        make.size.mas_equalTo(companyTextField);
    }];

    [timerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressTextField);
        make.top.equalTo(addressTextField.mas_bottom).with.offset(20);
        make.size.mas_equalTo(companyTextField);
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(timerTextField.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(100,50));
    }];

}

- (void)btnAction {


    if ([[CoreDataModel shareCoreDataModel] saveInformation:_informationDic]) {
        NSLog(@"保存成功");
//        UIAlertController
    }else {
        NSLog(@"保存失败");
    }

}

#pragma mark - textFeildDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField.tag == 101) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 30, self.view.frame.size.width, self.view.frame.size.height);
    }else if (textField.tag == 102){
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 30, self.view.frame.size.width, self.view.frame.size.height);
    }
//    [textField becomeFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField  resignFirstResponder];
    self.view.frame = _rect;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

//    [textField  resignFirstResponder];
    if (textField.tag == 100) {
        [_informationDic setValue:textField.text forKey:@"name"];
    }else if (textField.tag == 101){
        [_informationDic setValue:textField.text forKey:@"address"];
    }else if (textField.tag == 102){
        [_informationDic setValue:textField.text forKey:@"time"];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end








