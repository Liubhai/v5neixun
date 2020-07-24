//
//  MYTreeTableManager.h
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import <Foundation/Foundation.h>
#import "MYTreeItem.h"
#import "CourseListModel.h"

@interface MYTreeTableManager : NSObject

/** 初始化，ExpandLevel 为 0 全部折叠，为 1 展开一级，以此类推，为 NSIntegerMax 全部展开 */
- (instancetype)initWithItems:(NSSet<CourseListModel *> *)items andExpandLevel:(NSInteger)level;

/** 获取所有的 items */
@property (nonatomic, strong, readonly) NSMutableArray<CourseListModel *> *allItems;
/** 获取可见的 items */
@property (nonatomic, strong, readonly) NSMutableArray<CourseListModel *> *showItems;
/** 获取指定的 item */
- (CourseListModel *)getItemById:(NSString *)itemId;
/** 获取所有已经勾选的 item */
@property (nonatomic, strong, readonly) NSArray<CourseListModel *> *allCheckItem;

/** 展开/折叠到多少层级 */
- (void)expandItemWithLevel:(NSInteger)expandLevel completed:(void(^)(NSArray *noExpandArray))noExpandCompleted andCompleted:(void(^)(NSArray *expandArray))expandCompleted;
/** 展开/收起 item，返回所改变的 item 的个数 */
- (NSInteger)expandItem:(CourseListModel *)item;
- (NSInteger)expandItem:(CourseListModel *)item isExpand:(BOOL)isExpand;


@end
