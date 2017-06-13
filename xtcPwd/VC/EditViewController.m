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

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *doneItem   ;
@property (weak, nonatomic) IBOutlet UITextField        *nameTf     ;
@property (weak, nonatomic) IBOutlet UITextField        *accountTf  ;
@property (weak, nonatomic) IBOutlet UITextField        *passwordTf ;
@property (weak, nonatomic) IBOutlet UITextView         *detailTv   ;
@end

@implementation EditViewController

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.typeWillBeAdd != 0)
    { // add mode
        self.title = @"ADD" ;
    }
    else if (self.itemWillBeEdit != nil)
    { // edit mode
        _nameTf.text = self.itemWillBeEdit.name ;
        _accountTf.text = self.itemWillBeEdit.account ;
        _passwordTf.text = [self.itemWillBeEdit decodePwd] ;
        _detailTv.text = self.itemWillBeEdit.detailInfo ;
        
        self.title = @"EDIT" ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (IBAction)doneItemOnClick:(id)sender
{
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

- (void)addAction
{
    PwdItem *item = [[PwdItem alloc] initWithName:_nameTf.text
                                          account:_accountTf.text
                                         password:_passwordTf.text
                                           detail:_detailTv.text
                                             type:self.typeWillBeAdd] ;
    int idItem = [item insert] ;
    if (idItem) {
        [self.navigationController popViewControllerAnimated:YES] ;
        self.addItemSuccessBlock() ;
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"add fail"] ;
    }
}

- (void)editAction
{
    PwdItem *item = [[PwdItem alloc] initWithName:_nameTf.text
                                          account:_accountTf.text
                                         password:_passwordTf.text
                                           detail:_detailTv.text
                                             type:self.itemWillBeEdit.typeOfPwdItem] ;
    item.pkid = self.itemWillBeEdit.pkid ;
    BOOL bSuccess = [item update] ;
    if (bSuccess) {
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"edit fail"] ;
    }
}

#pragma mark - 



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
