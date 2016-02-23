//
//  Company+CoreDataProperties.h
//  interView
//
//  Created by lsh726 on 16/2/22.
//  Copyright © 2016年 liusonghong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Company.h"

NS_ASSUME_NONNULL_BEGIN

@interface Company (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *time;

@end

NS_ASSUME_NONNULL_END
