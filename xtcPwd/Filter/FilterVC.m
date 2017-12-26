//
//  FilterVC.m
//  xtcPwd
//
//  Created by teason23 on 2017/12/26.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "FilterVC.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "UIColor+AllColors.h"
#import "UIImage+AddFunction.h"

@interface FilterVC ()
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (weak, nonatomic) IBOutlet UIButton *searchClearButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *imageClose;
@end

@implementation FilterVC

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    self.fd_prefersNavigationBarHidden = YES ;
    
    self.view.backgroundColor = [UIColor xt_main] ;
    self.topBackView.backgroundColor = [UIColor xt_main] ;
    self.searchBackView.backgroundColor = [UIColor whiteColor] ;
    self.imageClose.image = [[UIImage imageNamed:@"close2"] imageWithTintColor:[UIColor xt_main]] ;
    self.imageClose.layer.cornerRadius = 10. ;
    self.imageClose.layer.masksToBounds = YES ;
    self.searchBackView.layer.cornerRadius = self.searchClearButton.frame.size.height / 2. ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
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
