//
//  TeacherCategoryModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TeacherCategoryModel,CateGoryModelSecond,CateGoryModelThird;

@interface TeacherCategoryModel : NSObject

@property (strong, nonatomic) NSString *cateGoryId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *child;
@property (strong, nonatomic) CateGoryModelThird *all;
@property (assign, nonatomic) BOOL selected;

@end

@interface CateGoryModelSecond : NSObject

@property (strong, nonatomic) NSString *cateGoryId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *child;
@property (assign, nonatomic) BOOL selected;

@end

@interface CateGoryModelThird : NSObject

@property (strong, nonatomic) NSString *cateGoryId;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL selected;

@end

NS_ASSUME_NONNULL_END
