//
//  UICollectionView+EmptyData.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/8/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (EmptyData)

/**
 *  @author SB
 *
 *  @brief 占位
 *
 *  @param message   消息
 *  @param imageName 图片名字
 *  @param rowCount  个数
 *  @param isLoding  是否在刷新或者加载
 */
- (void)collectionViewDisplayWitMsg:(NSString *)message img:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger)rowCount isLoading:(BOOL)isLoding tableViewShowHeight:(CGFloat)height;

@end
