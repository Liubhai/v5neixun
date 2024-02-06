//
//  OrderDetailAsCellView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/12/8.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailAsCellView : UIView

@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *theme;
@property (strong, nonatomic) UILabel *priceLabel;//售价
@property (strong, nonatomic) UILabel *scribing_price;//划线价格
@property (strong, nonatomic) UILabel *dateLine;
@property (strong, nonatomic) UILabel *countLabel;


- (void)setOrderDetailFinalInfo:(NSDictionary *)OrderFinalInfo orderStatus:(NSString *)orderStatus cellInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
