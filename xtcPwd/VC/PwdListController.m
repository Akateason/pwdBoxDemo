//
//  PwdListController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "PwdListController.h"
#import "ListCell.h"
#import "PwdItem.h"
#import "RootTableView.h"

@interface PwdListController () <UITableViewDelegate,UITableViewDataSource,RootTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *typeItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItem;
@property (weak, nonatomic) IBOutlet RootTableView *table;

@property (nonatomic,copy) NSArray *dataList ;
@property (nonatomic) TypeOfPwdItem pwdType ;
@end

@implementation PwdListController

#pragma mark --
- (void)setPwdType:(TypeOfPwdItem)pwdType
{
    _pwdType = pwdType ;
    
    switch (pwdType)
    {
        case typeNone:
        {
            self.title = @"All" ;
        }
            break;
        case typeWebsite:
        {
            self.title = @"Website" ;
        }
            break;
        case typeCard:
        {
            self.title = @"Card" ;
        }
            break;
        default:
            break;
    }
}

#pragma mark --
- (IBAction)typeItemOnClick:(id)sender
{
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"website"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        self.pwdType = typeWebsite ;
                                                    }] ;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"card"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        self.pwdType = typeCard ;
                                                    }] ;
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil] ;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"current type"
                                                                       message:@"choose a type"
                                                                preferredStyle:UIAlertControllerStyleActionSheet] ;
    [alertCtrl addAction:action1] ;
    [alertCtrl addAction:action2] ;
    [alertCtrl addAction:action3] ;
    [self.navigationController pushViewController:alertCtrl
                                         animated:YES] ;
}

- (IBAction)addItemOnClick:(id)sender
{
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"website"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        self.pwdType = typeWebsite ;
                                                    }] ;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"card"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        self.pwdType = typeCard ;
                                                    }] ;
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil] ;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"add an item"
                                                                       message:@"choose a type"
                                                                preferredStyle:UIAlertControllerStyleActionSheet] ;
    [alertCtrl addAction:action1] ;
    [alertCtrl addAction:action2] ;
    [alertCtrl addAction:action3] ;
    [self.navigationController pushViewController:alertCtrl
                                         animated:YES] ;

}

#pragma mark --
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.table.delegate = self ;
    self.table.dataSource = self ;
    self.table.xt_Delegate = self ;
    [self.table pullDownRefreshHeaderInBackGround:YES] ;
}

#pragma mark --
- (void)loadNew:(void(^)(void))endRefresh
{
    
}

- (void)loadMore:(void(^)(void))endRefresh
{
    
}

#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 ;
    //self.dataList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"] ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *lCell = cell ;
//    lCell.name = ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ListCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
