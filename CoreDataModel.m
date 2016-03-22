//
//  CoreDataModel.m
//  interView
//
//  Created by lsh726 on 16/2/22.
//  Copyright © 2016年 liusonghong. All rights reserved.
//

#import "CoreDataModel.h"
#import <CoreData/CoreData.h>

static CoreDataModel *_coredataModel = nil;


@interface CoreDataModel(){
  
}

@property (nonatomic, strong)NSManagedObjectContext *context;

@end


@implementation CoreDataModel

+ (instancetype)shareCoreDataModel {
    @synchronized(self) {
        if (!_coredataModel) {
            _coredataModel = [[CoreDataModel alloc]init];
        }
        return _coredataModel;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self openDB];
    }
    return self;
}

- (void)openDB {
    //数据模型
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //存储协调器
    NSPersistentStoreCoordinator *persistore = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[documentPath stringByAppendingString:@"/Company.data"]];
    NSError *error = nil;
    //添加持久化数据库 StoreWithType参数即是
    NSPersistentStore *store = [persistore addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"添加数据库错误" format:@"%@",[error localizedDescription]];
    }
    //初始化上下文
    self.context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = persistore;
}


- (BOOL)saveInformation:(NSDictionary *)dic{

    NSError *error = nil;
    if ([self update]) {
        [self.context deleteObject:[self update]];
        [self.context save:&error];
        if ([self.context save:&error]) {
            NSLog(@"删除成功");
        }
    }
    self.upCompany = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.context];
    self.upCompany.name    = [dic valueForKey:@"name"];
    self.upCompany.address = [dic valueForKey:@"address"];
    self.upCompany.time    = [dic valueForKey:@"time"];

    return [self.context save:&error];
}

- (Company *)update{
    // 初始化一个查询请求
    NSArray *array = [NSArray array];

    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Company"];
//    fetch.predicate = [NSPredicate predicateWithFormat:@"name == %@",kAccount];
    NSError *error;
    array = [self.context executeFetchRequest:fetch error:&error];
    Company *company = nil;
    if (array.count!=0) {
        company = array[0];
    }
    NSLog(@"%@",company.name);
    if (error) {
        NSLog(@"查询plug列表出错,%@",error.localizedDescription);
    }
    return company;
}

@end





