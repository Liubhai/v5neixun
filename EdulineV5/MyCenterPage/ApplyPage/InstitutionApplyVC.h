//
//  InstitutionApplyVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ScanPhotoViewController.h"
#import "UserModel.h"
#import "TeacherCategoryVC.h"
#import "TeacherCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstitutionApplyVC : BaseViewController<UIPickerViewDelegate, UIPickerViewDataSource,TYAttributedLabelDelegate,UIScrollViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,sendPhotoArrDelegate,UITextFieldDelegate,TeacherCategoryVCDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UIScrollView *nextScrollView;

@property (strong, nonatomic) UILabel *nameLeftLabel;
@property (strong, nonatomic) UILabel *nameRightLabel;

@property (strong, nonatomic) UILabel *willBeManagerLabel;

@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UILabel *statusLeftLabel;
@property (strong, nonatomic) UILabel *statusRightLabel;

@property (strong, nonatomic) UIView *line2;

@property (strong, nonatomic) UILabel *institutionLeftLabel;
@property (strong, nonatomic) UITextField *institutionTextField;
@property (strong, nonatomic) UILabel *institutionRightLabel;
@property (strong, nonatomic) UIButton *institutionIcon;

@property (strong, nonatomic) UIView *line3;

@property (strong, nonatomic) UILabel *industryLeftLabel;
@property (strong, nonatomic) UILabel *industryRightLabel;
@property (strong, nonatomic) UIButton *industryIcon;

@property (strong, nonatomic) UIView *industryBackView;

@property (strong, nonatomic) UIView *nextBackView;

@property (strong, nonatomic) UIView *nextLine4;

@property (strong, nonatomic) UILabel *logoLabel;
@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) UIView *nextLine5;

@property (strong, nonatomic) UILabel *institutionInroLabel;
@property (strong, nonatomic) UILabel *institutionInroPlace;
@property (strong, nonatomic) UITextView *institutionInroTextView;

@property (strong, nonatomic) UIView *nextLine6;

@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UITextField *phoneTextField;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *nextButton;


@property (strong, nonatomic) UIView *otherBackView;

@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *addressPlace;
@property (strong, nonatomic) UITextView *addressTextView;

@property (strong, nonatomic) UIView *line4;

@property (strong, nonatomic) UILabel *idCardLabel;
@property (strong, nonatomic) UITextField *idCardText;

@property (strong, nonatomic) UIView *line5;

@property (strong, nonatomic) UILabel *idCardPictureTitle;
@property (strong, nonatomic) UILabel *idCardPictureTip;

@property (strong, nonatomic) UIImageView *idCardPictureLeft;
@property (strong, nonatomic) UIImageView *idCardPictureLeftIocn;
@property (strong, nonatomic) UILabel *idCardPictureLeftLabel;

@property (strong, nonatomic) UIImageView *idCardPictureRight;
@property (strong, nonatomic) UIImageView *idCardPictureRightIocn;
@property (strong, nonatomic) UILabel *idCardPictureRightLabel;

@property (strong, nonatomic) UILabel *teacherPictureTitle;
@property (strong, nonatomic) UILabel *teacherPictureTip;

@property (strong, nonatomic) UIImageView *teacherPicture;
@property (strong, nonatomic) UIImageView *teacherPictureIocn;
@property (strong, nonatomic) UILabel *teacherPictureLabel;

@property (strong, nonatomic) UIView *bottomBackView;

@property (strong, nonatomic) UIView *agreeBackView;
@property (strong, nonatomic) TYAttributedLabel *agreementTyLabel;
@property (strong, nonatomic) UIButton *seleteBtn;

@property (strong, nonatomic) UIButton *submitButton;

@end

NS_ASSUME_NONNULL_END
