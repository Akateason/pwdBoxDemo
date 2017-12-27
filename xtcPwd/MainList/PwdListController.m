//
//  PwdListController.m
//  xtcPwd
//
//  Created by teason23 on 2017/6/13.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "PwdListController.h"
#import "EditViewController.h"
#import "DetailViewController.h"
#import "ListCell.h"
#import "PwdItem.h"
#import "RootTableView.h"
#import <ReactiveObjC.h>
#import "SVProgressHUD.h"
#import "UIColor+AllColors.h"
#import "UIImage+AddFunction.h"
#import "PingTransition.h"
#import <Masonry.h>
#import "ScreenHeader.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "UserViewController.h"
#import "CellPositiveTransition.h"
#import "FilterCondition.h"
#import "SearchPositiveTransition.h"
#import "SearchVC.h"

@interface PwdListController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,FilterDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btAdd;

@property (nonatomic,copy) NSArray *dataList ;
@property (nonatomic) TypeOfPwdItem pwdType ;

@end

@implementation PwdListController

#pragma mark - search

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (![searchText length]) return ;
//
//    self.dataList = [PwdItem selectWhere:[NSString stringWithFormat:@"name like '%%%@%%'",searchText]] ;
//    [self.table reloadData] ;
//}

#pragma mark - FilterDelegate <NSObject>

- (void)confirmWithFilter:(FilterCondition *)condition {
    self.pwdType = condition.filterCate ;
    
    switch (self.pwdType) {
        case typeNone:      self.title = @"ALL" ;       break ;
        case typeWebsite:   self.title = @"Website" ;   break ;
        case typeCard:      self.title = @"Card" ;      break ;
        default: break ;
    }
    self.titleLabel.text = self.title ;
    [self refreshTable] ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    self.fd_prefersNavigationBarHidden = YES ;
    
    [[FilterCondition sharedSingleton] setup] ;
    
    [self setupUIs] ;
    [self setupTable] ;
    [self refreshTable] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    _btAdd.hidden = NO ;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    self.navigationController.delegate = self ;
}

- (void)setupUIs {
    self.view.backgroundColor = [UIColor xt_main] ;
    [self.btUser setImage:[[UIImage imageNamed:@"user"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    [self.btAdd setImage:[[UIImage imageNamed:@"add"] imageWithTintColor:[UIColor xt_main]] forState:0] ;
    [self.btSearch setImage:[[UIImage imageNamed:@"searchBt"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
}

- (void)setupTable {
    self.table.delegate     = self ;
    self.table.dataSource   = self ;
    self.table.backgroundColor = [UIColor xt_bg] ; // [UIColor whiteColor] ;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.table.estimatedRowHeight = 0 ;
    self.table.estimatedSectionHeaderHeight = 0 ;
    self.table.estimatedSectionFooterHeight = 0 ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - actions

- (IBAction)searchBtOnClick:(id)sender {
    [self performSegueWithIdentifier:@"home2search" sender:nil] ;
}

- (IBAction)userOnClick:(id)sender {
    [self performSegueWithIdentifier:@"all2user" sender:nil] ;
}

- (IBAction)addItemOnClick:(id)sender {
    [self performSegueWithIdentifier:@"home2add" sender:nil] ;
    
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"website"
//                                                      style:UIAlertActionStyleDefault
//                                                    handler:^(UIAlertAction * _Nonnull action) {
//                                                        [self performSegueWithIdentifier:@"list2add"
//                                                                                  sender:@(typeWebsite)] ;
//                                                    }] ;
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"card"
//                                                      style:UIAlertActionStyleDefault
//                                                    handler:^(UIAlertAction * _Nonnull action) {
//                                                        [self performSegueWithIdentifier:@"list2add"
//                                                                                  sender:@(typeCard)] ;
//                                                    }] ;
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"cancel"
//                                                      style:UIAlertActionStyleCancel
//                                                    handler:nil] ;
//    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"ADD"
//                                                                       message:@"Select type that will be added ."
//                                                                preferredStyle:UIAlertControllerStyleActionSheet] ;
//    [alertCtrl addAction:action1] ;
//    [alertCtrl addAction:action2] ;
//    [alertCtrl addAction:action3] ;
//    [self presentViewController:alertCtrl
//                       animated:YES
//                     completion:nil] ;
    
}

#pragma mark --

- (void)refreshTable {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    dispatch_async(queue, ^{
        NSArray *listBack = [PwdItem findWithSql:[self sqlWhereString]] ;
        self.dataList = listBack ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData] ;
        }) ;
    }) ;
}

- (NSString *)sqlWhereString {
    
    NSString *orderBy = @"pinyin" ;
    switch ([FilterCondition sharedSingleton].sortByType) {
        case sortByType_spell: orderBy = @"pinyin" ; break;
        case sortByType_time: orderBy = @"updateTime" ; break;
        case sortByType_read: orderBy = @"readCount" ; break;
        default:
            break;
    }
    
    NSString *ascOrDesc = [FilterCondition sharedSingleton].isAscOrDesc ? @"ASC" : @"DESC" ;
    
    return !self.pwdType
    ?
    STR_FORMAT(@"SELECT * FROM PwdItem ORDER BY %@ %@",orderBy,ascOrDesc)
    :
    STR_FORMAT(@"SELECT * FROM PwdItem WHERE typeOfPwdItem == %d ORDER BY %@ %@",(int)self.pwdType,orderBy,ascOrDesc) ;
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"ListCell"] ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PwdItem *item = self.dataList[indexPath.row] ;
    [cell configure:item] ;
    
    cell.image.alpha = 0. ;
    [UIView animateWithDuration:0.2
                     animations:^{
                         cell.image.alpha = 0.8 ;
                     }
                     completion:^(BOOL finished) {
                         cell.image.layer.transform = indexPath.row % 2 ? CATransform3DMakeTranslation(-10, 0, 0) : CATransform3DMakeTranslation(10, 0, 0) ;
                         [UIView animateWithDuration:.4
                                               delay:0
                              usingSpringWithDamping:.5
                               initialSpringVelocity:0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              cell.image.layer.transform = CATransform3DIdentity ;
                                          }
                                          completion:nil] ;
                     }] ;
    
    cell.layer.transform = CATransform3DMakeScale(0.76, 0.76, 1) ;
    [UIView animateWithDuration:.25
                     animations:^{
                         cell.layer.transform = CATransform3DIdentity ;
                     }] ;

    cell.name.alpha = 0. ;
    cell.account.alpha = 0. ;
    [UIView animateWithDuration:1.6
                     animations:^{
                         cell.name.alpha = 1. ;
                         cell.account.alpha = 1. ;
                     }] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ListCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PwdItem *item = self.dataList[indexPath.row] ;
    [self performSegueWithIdentifier:@"list2detail" sender:item] ;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES ;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete ;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        @weakify(self)
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"Confirm"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            @strongify(self)
                                                            [self doDelete:indexPath] ;
                                                        }] ;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil] ;
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"Remove"
                                                                           message:@"Are you sure to remove this item ???"
                                                                    preferredStyle:UIAlertControllerStyleAlert] ;
        [alertCtrl addAction:action0] ;
        [alertCtrl addAction:action1] ;
        [self presentViewController:alertCtrl animated:YES completion:nil] ;
    }
}

- (void)doDelete:(NSIndexPath *)indexPath
{
    PwdItem *item = self.dataList[indexPath.row] ;
    BOOL bDel = [item deleteModel] ;
    if (!bDel)
    {
        [SVProgressHUD showErrorWithStatus:@"delete fail"] ;
        return ;
    }
    
    NSMutableArray *tmplist = [self.dataList mutableCopy] ;
    [tmplist removeObjectAtIndex:indexPath.row] ;
    self.dataList = tmplist ;
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                      withRowAnimation:UITableViewRowAnimationFade] ;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        if ([toVC isKindOfClass:[UserViewController class]]) {
            return [PingTransition new] ;
        }
        else if ([toVC isKindOfClass:[DetailViewController class]]) {
            _btAdd.hidden = YES ;
            return [CellPositiveTransition new] ;
        }
        else if ([toVC isKindOfClass:[SearchVC class]]) {
            return [SearchPositiveTransition new] ;
        }
        
        return nil ;
    }
    else {
        return nil ;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"list2add"]) {
        EditViewController *addVC = [segue destinationViewController] ;
        addVC.typeWillBeAdd = [sender intValue] ;
        @weakify(self)
        addVC.addItemSuccessBlock = ^{
            @strongify(self)
            [self refreshTable] ;
        } ;
    }
    else if ([segue.identifier isEqualToString:@"list2detail"]) {
        DetailViewController *detailVC = [segue destinationViewController] ;
        detailVC.item = sender ;
    }
    else if ([segue.identifier isEqualToString:@"all2user"]) {
        UserViewController *userVC = [segue destinationViewController] ;
        userVC.delegate = self ;
    }
}

@end
