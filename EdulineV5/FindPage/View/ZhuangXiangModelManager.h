//
//  ZhuangXiangModelManager.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhuanXiangModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhuangXiangModelManager : NSObject

/** 初始化，ExpandLevel 为 0 全部折叠，为 1 展开一级，以此类推，为 NSIntegerMax 全部展开 */
- (instancetype)initWithItems:(NSSet<ZhuanXiangModel *> *)items andExpandLevel:(NSInteger)level;

/** 获取所有的 items */
@property (nonatomic, strong, readonly) NSMutableArray<ZhuanXiangModel *> *allItems;
/** 获取可见的 items */
@property (nonatomic, strong, readonly) NSMutableArray<ZhuanXiangModel *> *showItems;
/** 获取指定的 item */
- (ZhuanXiangModel *)getItemById:(NSString *)itemId;
/** 获取所有已经勾选的 item */
@property (nonatomic, strong, readonly) NSArray<ZhuanXiangModel *> *allCheckItem;

/** 展开/折叠到多少层级 */
- (void)expandItemWithLevel:(NSInteger)expandLevel completed:(void(^)(NSArray *noExpandArray))noExpandCompleted andCompleted:(void(^)(NSArray *expandArray))expandCompleted;
/** 展开/收起 item，返回所改变的 item 的个数 */
- (NSInteger)expandItem:(ZhuanXiangModel *)item;
- (NSInteger)expandItem:(ZhuanXiangModel *)item isExpand:(BOOL)isExpand;

@end

NS_ASSUME_NONNULL_END