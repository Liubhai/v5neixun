//
//  ShopMainListCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/8/12.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShopMainListCellDelegate <NSObject>

@optional
- (void)exchangeNowButton:(NSDictionary *)shopInfo;

@end

@interface ShopMainListCell : UICollectionViewCell

@property (nonatomic, weak) id<ShopMainListCellDelegate> delegate;
@property (strong, nonatomic) UIView *whiteBackView;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UILabel *shopTitle;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UILabel *originPriceLabel;
@property (strong, nonatomic) UIButton *exchangeButton;
@property (strong, nonatomic) NSDictionary *shopInfoDt;

- (void)setShopMainListInfo:(NSDictionary *)info cellIndex:(NSIndexPath *)cellIndex;

@end

NS_ASSUME_NONNULL_END
