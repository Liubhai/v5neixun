//
//  AddressTableViewCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2022/10/25.
//  Copyright © 2022 刘邦海. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "V5_Constant.h"

@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = EdlineV5_Color.backColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 6, MainScreenWidth - 15 * 2, 145)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.masksToBounds = YES;
//    _backView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _backView.layer.cornerRadius = 4;
//    _backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
//    _backView.layer.shadowOffset = CGSizeMake(0,1);
//    _backView.layer.shadowOpacity = 1;
//    _backView.layer.shadowRadius = 6;
    [self.contentView addSubview:_backView];
    
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, _backView.width, 21 + 13 * 2)];
    _namelabel.text = @"李晓";
    _namelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _namelabel.textColor = EdlineV5_Color.textFirstColor;
    [_backView addSubview:_namelabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.width - 12 - 100, 0, 100, _namelabel.height)];
    _phoneLabel.text = @"19892829210";
    _phoneLabel.font = SYSTEMFONT(15);
    _phoneLabel.textColor = EdlineV5_Color.textFirstColor;
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:_phoneLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, _namelabel.bottom, _backView.width - 12, 20)];
    _addressLabel.font = SYSTEMFONT(14);
    _addressLabel.textColor = EdlineV5_Color.textSecendColor;
    _addressLabel.text = @"四川省成都市武侯区环球中心";
    [_backView addSubview:_addressLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(12, _addressLabel.bottom + 15, _backView.width - 12 - 14, 2)];
    _lineView.backgroundColor = EdlineV5_Color.fengeLineColor;
    [_backView addSubview:_lineView];
    
    _defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(12, _lineView.bottom + 18, 86 + 8 + 20, 20)];
    [_defaultButton setImage:Image(@"checkbox_def") forState:0];
    [_defaultButton setImage:[Image(@"checkbox_blue") converToMainColor] forState:UIControlStateSelected];
    [_defaultButton addTarget:self action:@selector(seleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_defaultButton setTitle:@"设为默认地址" forState:0];
    _defaultButton.titleLabel.font = SYSTEMFONT(14);
    [_defaultButton setTitleColor:EdlineV5_Color.textSecendColor forState:0];
    _defaultButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    _defaultButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    [_backView addSubview:_defaultButton];
    
    _updateButton = [[UIButton alloc] initWithFrame:CGRectMake(_backView.width - 14 - 70, _lineView.bottom + 18, 70, 28)];
    _updateButton.layer.masksToBounds = YES;
    _updateButton.layer.cornerRadius = _updateButton.height / 2.0;
    _updateButton.backgroundColor = EdlineV5_Color.themeColor;
    [_updateButton setTitle:@"修改" forState:0];
    [_updateButton setTitleColor:[UIColor whiteColor] forState:0];
    _updateButton.titleLabel.font = SYSTEMFONT(13);
    [_updateButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_updateButton];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(_updateButton.left - 12 - 70, _lineView.bottom + 18, 70, 28)];
    _deleteButton.layer.masksToBounds = YES;
    _deleteButton.layer.cornerRadius = _updateButton.height / 2.0;
    _deleteButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _deleteButton.layer.borderWidth = 1;
    _deleteButton.backgroundColor = [UIColor whiteColor];
    [_deleteButton setTitle:@"删除" forState:0];
    [_deleteButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    _deleteButton.titleLabel.font = SYSTEMFONT(13);
    [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_deleteButton];
}

- (void)setAddressInfo:(NSDictionary *)addressInfo {
    _currentAddressInfo = addressInfo;
    _namelabel.text = [NSString stringWithFormat:@"%@",addressInfo[@"consignee"]];
    _phoneLabel.text = [NSString stringWithFormat:@"%@",addressInfo[@"phone"]];
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@",addressInfo[@"areatext"],addressInfo[@"address"]];
    _defaultButton.selected = [[NSString stringWithFormat:@"%@",addressInfo[@"default"]] integerValue];
}

- (void)seleteButtonClick:(UIButton *)sender {
    _defaultButton.selected = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(changeDefaultAddress:)]) {
        [_delegate changeDefaultAddress:self];
    }
}

- (void)deleteButtonClick {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteAddress:)]) {
        [_delegate deleteAddress:self];
    }
}

- (void)changeButtonClick {
    if (_delegate && [_delegate respondsToSelector:@selector(changeAddress:)]) {
        [_delegate changeAddress:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
