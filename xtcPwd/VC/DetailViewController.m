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

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UILabel *lbPwd;
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editItem;
@end

@implementation DetailViewController


- (IBAction)editOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"detail2edit" sender:self.item] ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.item) return ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    // fetch from db .
    self.item = [PwdItem findFirstWhere:[NSString stringWithFormat:@"pkid == %d",self.item.pkid]] ;
    
    _lbName.text = self.item.name ;
    _lbAccount.text = self.item.account ;
    _lbPwd.text = [self.item decodePwd] ;
    _lbDetail.text = self.item.detailInfo ;
    
    self.title = self.item.name ;
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
