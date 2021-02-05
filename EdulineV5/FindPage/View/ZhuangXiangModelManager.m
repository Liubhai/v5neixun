//
//  ZhuangXiangModelManager.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ZhuangXiangModelManager.h"

@interface ZhuangXiangModelManager ()

@property (nonatomic, strong) NSDictionary<NSString *, ZhuanXiangModel *> *itemsMap;
@property (nonatomic, strong) NSMutableArray <ZhuanXiangModel *>*topItems;
@property (nonatomic, strong) NSMutableArray <ZhuanXiangModel *>*tmpItems;
@property (nonatomic, assign) NSInteger maxLevel;   // 获取最大等级
@property (nonatomic, assign) NSInteger showLevel;  // 设置最大的等级

@end

@implementation ZhuangXiangModelManager


- (instancetype)initWithItems:(NSSet<ZhuanXiangModel *> *)items andExpandLevel:(NSInteger)level
{
    self = [super init];
    if (self) {
        
        // 1. 建立 MAP
        [self setupItemsMapByItems:items];
        
        // 2. 建立父子关系，并得到顶级节点
        [self setupTopItemsWithFilterField:nil];
        
        // 3. 设置等级
        [self setupItemsLevel];
        
        // 4. 根据展开等级设置 showItems
        [self setupShowItemsWithShowLevel:level];
    }
    return self;
}

// 建立 MAP
- (void)setupItemsMapByItems:(NSSet *)items {
    
    NSMutableDictionary *itemsMap = [NSMutableDictionary dictionary];
    for (ZhuanXiangModel *item in items) {
        [itemsMap setObject:item forKey:item.course_id];
    }
    self.itemsMap = itemsMap.copy;
}

// 建立父子关系，并得到顶级节点
- (void)setupTopItemsWithFilterField:(NSString *)field {
    
    self.tmpItems = self.itemsMap.allValues.mutableCopy;
    
    // 建立父子关系
    NSMutableArray *topItems = [NSMutableArray array];
    for (ZhuanXiangModel *item in self.tmpItems) {
        
        item.isExpand = NO;
        
        ZhuanXiangModel *parent = self.itemsMap[item.parentID];
        if (parent) {
            item.parentItem = parent;
            if (![parent.child containsObject:item]) {
                [parent.child addObject:item];
            }
        } else {
            [topItems addObject:item];
        }
    }
    
    // 顶级节点排序
    self.topItems = [topItems sortedArrayUsingComparator:^NSComparisonResult(ZhuanXiangModel *obj1, ZhuanXiangModel *obj2) {
        return [obj1.orderNo compare:obj2.orderNo];
    }].mutableCopy;
    
    // 所有 item 排序
    for (ZhuanXiangModel *item in self.tmpItems) {
        item.child = [item.child sortedArrayUsingComparator:^NSComparisonResult(ZhuanXiangModel *obj1, ZhuanXiangModel *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
    }
}

// 设置等级
- (void)setupItemsLevel {
    
    for (ZhuanXiangModel *item in self.tmpItems) {
        int tmpLevel = 0;
        ZhuanXiangModel *p = item.parentItem;
        while (p) {
            tmpLevel++;
            p = p.parentItem;
        }
        item.level = tmpLevel;
        
        // 设置最大等级
        _maxLevel = MAX(_maxLevel, tmpLevel);
    }
}

// 根据展开等级设置 showItems
- (void)setupShowItemsWithShowLevel:(NSInteger)level {
    
    _showLevel = MAX(level, 0);
    _showLevel = MIN(level, _maxLevel);
 
    NSMutableArray *showItems = [NSMutableArray array];
    for (ZhuanXiangModel *item in self.topItems) {
        [self addItem:item toShowItems:showItems andAllowShowLevel:_showLevel];
    }
    _showItems = showItems;
}

- (void)addItem:(ZhuanXiangModel *)item toShowItems:(NSMutableArray *)showItems andAllowShowLevel:(NSInteger)level {
    
    if (item.level <= level) {
        
        [showItems addObject:item];
        
        item.isExpand = !(item.level == level);
        item.child = [item.child sortedArrayUsingComparator:^NSComparisonResult(ZhuanXiangModel *obj1, ZhuanXiangModel *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
        
        for (ZhuanXiangModel *childItem in item.child) {
            [self addItem:childItem toShowItems:showItems andAllowShowLevel:level];
        }
    }
}


#pragma mark - Expand Item

// 展开/收起 Item，返回所改变的 Item 的个数
- (NSInteger)expandItem:(ZhuanXiangModel *)item {
    return [self expandItem:item isExpand:!item.isExpand];
}

- (NSInteger)expandItem:(ZhuanXiangModel *)item isExpand:(BOOL)isExpand {
    
    if (item.isExpand == isExpand) return 0;
    item.isExpand = isExpand;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    // 如果展开
    if (isExpand) {
        for (ZhuanXiangModel *tmpItem in item.child) {
            [self addItem:tmpItem toTmpItems:tmpArray];
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.showItems indexOfObject:item] + 1, tmpArray.count)];
        [self.showItems insertObjects:tmpArray atIndexes:indexSet];
    }
    // 如果折叠
    else {
        for (ZhuanXiangModel *tmpItem in self.showItems) {
            
            BOOL isParent = NO;
            
            ZhuanXiangModel *parentItem = tmpItem.parentItem;
            while (parentItem) {
                if (parentItem == item) {
                    isParent = YES;
                    break;
                }
                parentItem = parentItem.parentItem;
            }
            if (isParent) {
                [tmpArray addObject:tmpItem];
            }
        }
        [self.showItems removeObjectsInArray:tmpArray];
    }
    
    return tmpArray.count;
}
- (void)addItem:(ZhuanXiangModel *)item toTmpItems:(NSMutableArray *)tmpItems {
    
    [tmpItems addObject:item];
    
    if (item.isExpand) {
        
        item.child = [item.child sortedArrayUsingComparator:^NSComparisonResult(ZhuanXiangModel *obj1, ZhuanXiangModel *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
        
        for (ZhuanXiangModel *tmpItem in item.child) {
            [self addItem:tmpItem toTmpItems:tmpItems];
        }
    }
}

// 展开/折叠到多少层级
- (void)expandItemWithLevel:(NSInteger)expandLevel completed:(void (^)(NSArray *))noExpandCompleted andCompleted:(void (^)(NSArray *))expandCompleted {
    
    expandLevel = MAX(expandLevel, 0);
    expandLevel = MIN(expandLevel, self.maxLevel);
    
    // 先一级一级折叠
    for (NSInteger level = self.maxLevel; level >= expandLevel; level--) {
        
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.showItems.count; i++) {
            
            ZhuanXiangModel *item = self.showItems[i];
            if (item.isExpand && item.level == level) {
                [itemArray addObject:item];
            }
        }
        
        if (itemArray.count) {
            if (noExpandCompleted) {
                noExpandCompleted(itemArray);
            }
        }
    }
    
    // 再一级一级展开
    for (NSInteger level = 0; level < expandLevel; level++) {
        
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.showItems.count; i++) {
            
            ZhuanXiangModel *item = self.showItems[i];
            if (!item.isExpand && item.level == level) {
                [itemArray addObject:item];
            }
        }
        
        if (itemArray.count) {
            if (expandCompleted) {
                expandCompleted(itemArray);
            }
        }
    }
}

#pragma mark - Filter Item

- (void)addItem:(ZhuanXiangModel *)item toShowItems:(NSMutableArray *)showItems {
    
    [showItems addObject:item];
    
    if (item.child.count) {
        
        item.child = [item.child sortedArrayUsingComparator:^NSComparisonResult(ZhuanXiangModel *obj1, ZhuanXiangModel *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
        
        for (ZhuanXiangModel *childItem in item.child) {
            if (item.isExpand) {
                [self addItem:childItem toShowItems:showItems];
            }
        }
    }
}


#pragma mark - Get

// 根据 id 获取 item
- (ZhuanXiangModel *)getItemById:(NSString *)itemId {
    
    if (itemId) {
        return self.itemsMap[itemId];
    } else {
        return nil;
    }
}

@end
