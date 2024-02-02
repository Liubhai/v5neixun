//
//  ShopContentView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/11/11.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopContentView : UIView

@property (strong, nonatomic) UILabel *shopTitleLabel;
@property (strong, nonatomic) UILabel *saleNumLabel;
@property (strong, nonatomic) UILabel *storageLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *originPriceLabel;

- (void)setShopContentInfo:(NSDictionary *)shopInfo;

@end

NS_ASSUME_NONNULL_END
