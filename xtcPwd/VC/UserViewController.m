//
//  UserViewController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/15.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btClose;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btCloseOnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
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
