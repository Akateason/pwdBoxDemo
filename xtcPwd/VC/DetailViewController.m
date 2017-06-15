//
//  DetailViewController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"
#import "PwdItem.h"
#import "UIColor+AllColors.h"
#import "SVProgressHUD.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPwd;
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem;
@property (weak, nonatomic) IBOutlet UIButton *btCopy;
@property (weak, nonatomic) IBOutlet UIButton *btShow;

@end

@implementation DetailViewController

#pragma mark -
- (IBAction)editOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"detail2edit" sender:self.item] ;
}

- (IBAction)copyOnClick:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard] ;
    pasteboard.string = [self.item decodePwd] ;
    [SVProgressHUD showInfoWithStatus:@"Already Copied To The Clipboard"] ;
}

- (IBAction)showOnClick:(id)sender
{
    _lbPwd.text = [self.item decodePwd] ;
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor xt_d_red] ;
    _lbName.textColor = [UIColor xt_dart] ;
    _lbAccount.textColor = [UIColor xt_dart] ;
    _lbPwd.textColor = [UIColor xt_dart] ;
    _lbDetail.textColor = [UIColor xt_dart] ;

    [_btCopy setTitleColor:[UIColor xt_dart] forState:0] ;
    [_btShow setTitleColor:[UIColor xt_dart] forState:0] ;
    _btCopy.layer.cornerRadius = 5. ;
    _btShow.layer.cornerRadius = 5. ;
    _btCopy.backgroundColor = [UIColor xt_light] ;
    _btShow.backgroundColor = [UIColor xt_light] ;
    
    if (!self.item) return ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    // fetch from db .
    self.item = [PwdItem findFirstWhere:[NSString stringWithFormat:@"pkid == %d",self.item.pkid]] ;
    
    _lbName.text = self.item.name ;
    _lbAccount.text = self.item.account ;
    _lbPwd.text = [self makePwdHidden] ;
    _lbDetail.text = self.item.detailInfo ;
    
    self.title = self.item.name ;
}

- (NSString *)makePwdHidden
{
    int count = (int)[[self.item decodePwd] length] ;
    NSString *itemStr = @"*" ;
    NSMutableString *tmpStr = [@"" mutableCopy] ;
    for (int i = 0; i < count; i++)
    {
        [tmpStr appendString:itemStr] ;
    }
    return tmpStr ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail2edit"]) {
        EditViewController *editVC = [segue destinationViewController] ;
        editVC.itemWillBeEdit = sender ;
    }
}


@end
