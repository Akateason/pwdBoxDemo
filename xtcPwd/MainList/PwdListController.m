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
#import "JXGesturePasswordView.h"
#import "PingTransition.h"
#import "XTSegment.h"
#import <Masonry.h>
#import "ScreenHeader.h"
#import <UINavigationController+FDFullscreenPopGesture.h>


@interface PwdListController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,XTSegmentDelegate>

@property (strong, nonatomic) XTSegment *segment ;
@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIButton *btAdd;
@property (weak, nonatomic) IBOutlet UITableView *table;

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

- (IBAction)searchBt:(UIButton *)sender {
//    [self putSearchBt] ;
}

#pragma mark - XTSegmentDelegate <NSObject>

- (void)clickSegmentWith:(int)index {
    self.pwdType = index ;
    [self refreshTable] ;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad] ;
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    self.fd_prefersNavigationBarHidden = YES ;
    
    [self setupUIs] ;
//    [self gesturePwdView] ;
    [self setupTable] ;
    [self refreshTable] ;
}

- (void)setupUIs
{
    self.topContainer.backgroundColor = nil ;
    self.segment = ({
        XTSegment *segment = [[XTSegment alloc] initWithDataList:@[@"ALL",@"WEBSITE",@"CARD"]
                                                           imgBg:nil
                                                            size:self.topContainer.frame.size
                                                     normalColor:[UIColor colorWithWhite:.8 alpha:.8]
                                                     selectColor:[UIColor whiteColor]
                                                            font:[UIFont systemFontOfSize:16.]] ;
        [self.topContainer addSubview:segment] ;
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.topContainer) ;
        }] ;
        segment.delegate = self ;
        segment ;
    }) ;
    
    self.view.backgroundColor = [UIColor xt_main] ;
    [self.btUser setImage:[[UIImage imageNamed:@"user"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    [self.btAdd setImage:[[UIImage imageNamed:@"add"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
}

- (void)setupTable
{
    self.table.delegate     = self ;
    self.table.dataSource   = self ;
    self.table.backgroundColor = [UIColor whiteColor] ;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.table.estimatedRowHeight = 0 ;
    self.table.estimatedSectionHeaderHeight = 0 ;
    self.table.estimatedSectionFooterHeight = 0 ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)userOnClick:(id)sender {
    [self performSegueWithIdentifier:@"all2user" sender:nil] ;
}

- (IBAction)addItemOnClick:(id)sender {
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"website"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self performSegueWithIdentifier:@"list2add"
                                                                                  sender:@(typeWebsite)] ;
                                                    }] ;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"card"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self performSegueWithIdentifier:@"list2add"
                                                                                  sender:@(typeCard)] ;
                                                    }] ;
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil] ;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"ADD"
                                                                       message:@"Select type that will be added ."
                                                                preferredStyle:UIAlertControllerStyleActionSheet] ;
    [alertCtrl addAction:action1] ;
    [alertCtrl addAction:action2] ;
    [alertCtrl addAction:action3] ;
    [self presentViewController:alertCtrl
                       animated:YES
                     completion:nil] ;
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
    return !self.pwdType
    ?
    @"SELECT * FROM PwdItem ORDER BY pinyin ASC"
    :
    [NSString stringWithFormat:@"SELECT * FROM PwdItem WHERE typeOfPwdItem == %d ORDER BY pinyin ASC",(int)self.pwdType] ;
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
    [UIView animateWithDuration:0.4
                     animations:^{
                         cell.image.alpha = 0.8 ;
                     }] ;
    
    cell.layer.transform = CATransform3DMakeScale(0.76, 0.76, 1) ;
    [UIView animateWithDuration:.25
                     animations:^{
                         cell.layer.transform = CATransform3DIdentity ;
                     }] ;

    cell.image.layer.transform = indexPath.row % 2 ? CATransform3DMakeTranslation(-10, 0, 0) : CATransform3DMakeTranslation(10, 0, 0) ;
    [UIView animateWithDuration:.8
                          delay:.25
         usingSpringWithDamping:0.2
          initialSpringVelocity:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.image.layer.transform = CATransform3DIdentity ;
                     }
                     completion:nil] ;
    
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
        PingTransition *ping = [PingTransition new];
        return ping;
    }
    else {
        return nil;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"list2add"])
    {
        EditViewController *addVC = [segue destinationViewController] ;
        addVC.typeWillBeAdd = [sender intValue] ;
        @weakify(self)
        addVC.addItemSuccessBlock = ^{
            @strongify(self)
            self.pwdType = typeNone ;
            [self refreshTable] ;
        } ;
    }
    else if ([segue.identifier isEqualToString:@"list2detail"])
    {
        DetailViewController *detailVC = [segue destinationViewController] ;
        detailVC.item = sender ;
    }
    else if ([segue.identifier isEqualToString:@"all2user"])
    {
        self.navigationController.delegate = self ;
    }
}

@end
