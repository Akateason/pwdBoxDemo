//
//  EditViewController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "EditViewController.h"
#import "PwdItem.h"
#import "SVProgressHUD.h"
#import "XTColor+MyColors.h"
#import "MyTextField.h"
#import <UIImageView+WebCache.h>
#import <ReactiveObjC.h>
#import "PhotosVC.h"
#import "XTAnimation.h"
#import <XTlib.h>

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPwd;
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *doneItem   ;
@property (weak, nonatomic) IBOutlet MyTextField        *nameTf     ;
@property (weak, nonatomic) IBOutlet MyTextField        *accountTf  ;
@property (weak, nonatomic) IBOutlet MyTextField        *passwordTf ;
@property (weak, nonatomic) IBOutlet UITextView         *detailTv   ;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EditViewController

#pragma mark -

- (IBAction)imageTaped:(id)sender {
    [self performSegueWithIdentifier:@"edit2photos"
                              sender:self.imageView.image] ;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self setupUI] ;
    [self setData] ;
    
    @weakify(self)
    [[[self.doneItem rac_signalForSelector:@selector(action)]
      throttle:.6]
     subscribeNext:^(RACTuple * _Nullable x) {
         @strongify(self)
         [self doneItemOnClick] ;
     }] ;
    
    RAC(self.lbName,textColor) = [self.nameTf.rac_textSignal map:^id(NSString *x) {
        return x.length ? [XTColor xt_text_light] : [XTColor redColor] ;
    }] ;
    
    RAC(self.lbAccount,textColor) = [self.accountTf.rac_textSignal map:^id _Nullable(NSString *str) {
        return [str length] ? [XTColor xt_text_light] : [XTColor redColor] ;
    }] ;
    
    RAC(self.lbPwd,textColor) = [self.passwordTf.rac_textSignal map:^id _Nullable(NSString *str) {
        return [str length] ? [XTColor xt_text_light] : [XTColor redColor] ;
    }] ;
}

- (void)setData {
    if (self.typeWillBeAdd != 0) {
        // add mode
        self.title = @"ADD" ;
    }
    else if (self.itemWillBeEdit != nil) {
        // edit mode
        _nameTf.text = self.itemWillBeEdit.name ;
        _accountTf.text = self.itemWillBeEdit.account ;
        _passwordTf.text = [self.itemWillBeEdit decodePwd] ;
        _detailTv.text = self.itemWillBeEdit.detailInfo ;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:self.itemWillBeEdit.imageUrl]
                      placeholderImage:[UIImage imageNamed:@"logo"]] ;
        self.title = @"EDIT" ;
    }
}

- (void)setupUI {
    self.view.backgroundColor = [XTColor xt_bg] ;
    
    _lbName.textColor = [XTColor xt_text_light] ;
    _lbPwd.textColor = [XTColor xt_text_light] ;
    _lbDetail.textColor = [XTColor xt_text_light] ;
    _lbAccount.textColor = [XTColor xt_text_light] ;
    
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 6. ;
    _imageView.layer.masksToBounds = YES ;
    _nameTf.textColor = [XTColor xt_main] ;
    _accountTf.textColor = [XTColor xt_main] ;
    _passwordTf.textColor = [XTColor xt_main] ;
    _detailTv.textColor = [XTColor xt_main] ;
    
    _nameTf.backgroundColor = [UIColor whiteColor] ;
    _accountTf.backgroundColor = [UIColor whiteColor] ;
    _passwordTf.backgroundColor = [UIColor whiteColor] ;
    _detailTv.backgroundColor = [UIColor whiteColor] ;
    
    _nameTf.layer.cornerRadius = 5. ;
    _accountTf.layer.cornerRadius = 5. ;
    _passwordTf.layer.cornerRadius = 5. ;
    _detailTv.layer.cornerRadius = 5. ;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init] ;
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil] ;
    }] ;
    [self.view addGestureRecognizer:tap] ;
    
    if (self.itemWillBeEdit != nil) {
        [[self rac_signalForSelector:@selector(viewDidAppear:)]
         subscribeNext:^(RACTuple * _Nullable x) {
             [XTAnimation shakeRandomDirectionWithDuration:1.2
                                               AndWithView:_imageView] ;
             [XTAnimation shakeRandomDirectionWithDuration:.8
                                               AndWithView:_nameTf] ;
             [XTAnimation shakeRandomDirectionWithDuration:.8
                                               AndWithView:_accountTf] ;
             [XTAnimation shakeRandomDirectionWithDuration:.8
                                               AndWithView:_passwordTf] ;
             [XTAnimation shakeRandomDirectionWithDuration:.8
                                               AndWithView:_detailTv] ;
         }] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)doneItemOnClick {
    if (!_nameTf.text.length || !_accountTf.text.length || !_passwordTf.text.length) {
        [SVProgressHUD showErrorWithStatus:@"fill in required blanks : name,account,password"] ;
        return ;
    }
    
    if (self.typeWillBeAdd != 0) {
        // add mode
        [self addAction] ;
    }
    else if (self.itemWillBeEdit != nil) {
        // edit mode
        [self editAction] ;
    }
}

- (void)addAction {
    PwdItem *item = [[PwdItem alloc] initWithName:_nameTf.text
                                          account:_accountTf.text
                                         password:_passwordTf.text
                                           detail:_detailTv.text
                                           imgUrl:self.itemWillBeEdit.imageUrl
                                             type:self.typeWillBeAdd] ;
    int idItem = [item insert] ;
    if (idItem) {
        [self.navigationController popViewControllerAnimated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddFinishNote" object:nil] ;
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"add fail"] ;
    }
}

- (void)editAction {
    PwdItem *item = [[PwdItem alloc] initWithName:_nameTf.text
                                          account:_accountTf.text
                                         password:_passwordTf.text
                                           detail:_detailTv.text
                                           imgUrl:self.itemWillBeEdit.imageUrl
                                             type:self.typeWillBeAdd] ;
    item.pkid = self.itemWillBeEdit.pkid ;
    BOOL bSuccess = [item update] ;
    if (bSuccess) {
        [self.navigationController popViewControllerAnimated:YES] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteEditDone" object:item] ;
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"edit fail"] ;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // edit2photos
    PhotosVC *photoVC = [segue destinationViewController] ;
    photoVC.imageSend = sender ;
    photoVC.item = self.itemWillBeEdit ;
    
    RACReplaySubject *subject = [RACReplaySubject subject] ;
    WEAK_SELF
    [subject subscribeNext:^(NSString *newImageUrl) {
        if ([newImageUrl length]) {
            weakSelf.itemWillBeEdit.imageUrl = newImageUrl ;
            [weakSelf setData] ;
        }
    }] ;
    
    photoVC.subject = subject ;
}

@end
