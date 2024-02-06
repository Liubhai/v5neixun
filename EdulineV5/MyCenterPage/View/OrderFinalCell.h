//
//  OrderFinalCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/8.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OrderFinalCellDelegate <NSObject>

@optional
- (void)getPastLogisticNum:(NSString *)LogisticNum;

@end


@interface OrderFinalCell : UITableViewCell

@property (assign, nonatomic) id<OrderFinalCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *faceImageView;
@property (strong, nonatomic) UIImageView *courseTypeImage;
@property (strong, nonatomic) UILabel *theme;
@property (strong, nonatomic) UILabel *priceLabel;//售价
@property (strong, nonatomic) UILabel *scribing_price;//划线价格
@property (strong, nonatomic) UILabel *dateLine;
@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) UIView *logisticsView;// 物流信息
@property (strong, nonatomic) UILabel *logisticsLabel;
@property (strong, nonatomic) UIButton *logisticsButton;


- (void)setOrderFinalInfo:(NSDictionary *)OrderFinalInfo orderStatus:(NSString *)orderStatus cellInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
