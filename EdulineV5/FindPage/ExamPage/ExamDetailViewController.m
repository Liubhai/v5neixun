//
//  ExamDetailViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/2/5.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "ExamDetailViewController.h"
#import "TYAttributedLabel.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "ExamIDListModel.h"

@interface ExamDetailViewController ()

@end

@implementation ExamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void)getData {
    if (SWNOTEmptyStr(_examIds)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPointIdListNet] WithAuthorization:nil paramDic:@{@"point_ids":_examIds,@"module_id":_examType} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    NSArray *pass = [NSArray arrayWithArray:[ExamIDListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"rules"]]];
                    if (SWNOTEmptyArr(pass)) {
                        ExamIDListModel *passDict = (ExamIDListModel *)pass[0];
                        NSArray *passArray = [NSArray arrayWithArray:passDict.child];
                        if (SWNOTEmptyArr(passArray)) {
                            ExamIDModel *passfinalDict = (ExamIDModel *)passArray[0];
                            [self getExamDetailForExamIds:passfinalDict.topic_id];
                        }
                    }
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)getExamDetailForExamIds:(NSString *)examIds {
    if (SWNOTEmptyStr(examIds)) {
        [Net_API requestGETSuperAPIWithURLStr:[Net_Path examPointDetailDataNet] WithAuthorization:nil paramDic:@{@"topic_id":examIds} finish:^(id  _Nonnull responseObject) {
            if (SWNOTEmptyDictionary(responseObject)) {
                if ([[responseObject objectForKey:@"code"] integerValue]) {
                    
                    NSArray *pass = [NSArray arrayWithArray:[ExamDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
                    if (SWNOTEmptyArr(pass)) {
                        ExamDetailModel *model = (ExamDetailModel *)pass[0];
                        NSString *origin = [NSString stringWithFormat:@"%@",model.title];
                        UITextView *lable1111 = [[UITextView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 100)];
                        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithData:[origin dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];

                        lable1111.attributedText = [[NSAttributedString alloc] initWithAttributedString:attrString];
                        [lable1111 sizeToFit];
                        [lable1111 setHeight:lable1111.height];
                        [self.view addSubview:lable1111];
                    }
                    
                }
            }
        } enError:^(NSError * _Nonnull error) {
            
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
