//
//  AddressTableViewCell.h
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/25.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressTableViewCell;

@protocol AddressTableViewCellDelegate <NSObject>

@optional
- (void)changeDefaultAddress:(AddressTableViewCell *)cell;
- (void)deleteAddress:(AddressTableViewCell *)cell;
- (void)changeAddress:(AddressTableViewCell *)cell;

@end

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AddressTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) NSDictionary *currentAddressInfo;

- (void)setAddressInfo:(NSDictionary *)addressInfo;

@end

NS_ASSUME_NONNULL_END
