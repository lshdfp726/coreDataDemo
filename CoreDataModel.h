//
//  CoreDataModel.h
//  interView
//
//  Created by lsh726 on 16/2/22.
//  Copyright © 2016年 liusonghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
@interface CoreDataModel : NSObject


@property (nonatomic, strong)Company *upCompany;
+ (instancetype)shareCoreDataModel;

- (BOOL)saveInformation:(NSDictionary *)dic;

- (Company *)update;


@end
