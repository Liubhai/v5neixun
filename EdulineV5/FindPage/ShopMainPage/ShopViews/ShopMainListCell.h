//
//  ShopMainListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopMainListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *typeIcon;
@property (strong, nonatomic) UILabel *typeTitle;
@property (strong, nonatomic) UILabel *priceLabel;

- (void)setShopMainListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex;

@end

NS_ASSUME_NONNULL_END
