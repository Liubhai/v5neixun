//
//  ZhuanXiangModel.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZhuanXiangModel;

@interface ZhuanXiangModel : NSObject


//"id": 2,
//"title": "二级1",
//"level": 2,
//"topic_count": 3,
//"price": "0.00",
//"child":

@property (strong, nonatomic) NSString *course_id;
@property (nonatomic, weak)   ZhuanXiangModel *parentItem;
@property (nonatomic, strong) NSMutableArray<ZhuanXiangModel *> *child;
@property (nonatomic, assign) BOOL isLeaf;       // 是否叶子节点
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, strong) NSString *parentID;  // 父级节点唯一标识
@property (nonatomic, strong) NSString *orderNo;   // 序号
@property (nonatomic, strong) NSString *type;      // 类型

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *price;
@property (assign, nonatomic) BOOL has_bought;
@property (strong, nonatomic) NSString *topic_count;

@end

NS_ASSUME_NONNULL_END
