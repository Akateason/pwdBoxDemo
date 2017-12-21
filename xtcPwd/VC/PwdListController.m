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

@interface PwdListController () <UITableViewDelegate,UITableViewDataSource,RootTableViewDelegate,JXGesturePasswordViewDelegate,UINavigationControllerDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btAdd;
@property (weak, nonatomic) IBOutlet RootTableView *table;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;
@property (weak, nonatomic) IBOutlet UIButton *btSch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,copy) NSArray *dataList ;
@property (nonatomic) TypeOfPwdItem pwdType ;

@end

@implementation PwdListController

#pragma mark --

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText length]) return ;
    
    self.dataList = [PwdItem selectWhere:[NSString stringWithFormat:@"name like '%%%@%%'",searchText]] ;
    [self.table reloadData] ;
}

#pragma mark --

- (IBAction)searchBt:(UIButton *)sender {
    [self putSearchBt] ;
}

- (void)putSearchBt {
    self.btSch.selected = !self.btSch.selected ;
    self.tableTop.constant = self.btSch.selected ? (64 + 44) : 64 ;
    if (self.btSch.selected) {
        [self.searchBar becomeFirstResponder] ;
    }
    else {
        [self.searchBar resignFirstResponder] ;
    }
}



#pragma mark --

- (void)viewDidLoad
{
    [PwdItem createTable] ;
    
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.
    self.titleLb.textColor = [UIColor whiteColor] ;
    self.titleLb.text = @"All" ;
    [self setupUIs] ;
    [self gesturePwdView] ;
    self.searchBar.delegate = self ;
}

- (void)setupUIs
{
    self.view.backgroundColor  = [UIColor xt_dart] ;
    [self.btUser setImage:[[UIImage imageNamed:@"user"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    [self.btSwitch setImage:[[UIImage imageNamed:@"switch"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    [self.btAdd setImage:[[UIImage imageNamed:@"add"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
}

- (void)setupTable
{
    self.table.delegate     = self ;
    self.table.dataSource   = self ;
    self.table.xt_Delegate  = self ;
    [self.table pullDownRefreshHeaderInBackGround:YES] ;
    self.table.backgroundColor = [UIColor xt_d_red] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
- (void)gesturePwdView
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults] ;
    NSString *gesPwd = [userDefaultes objectForKey:@"gesturePwd"] ;
    if (gesPwd != nil) {
        JXGesturePasswordView *gesturePasswordView = [[JXGesturePasswordView alloc] init] ;
        gesturePasswordView.center = self.view.center ;
        gesturePasswordView.delegate = self ;
        [self.view addSubview:gesturePasswordView] ;
    }
    else {
        [self performSegueWithIdentifier:@"all2user" sender:nil] ;
    }
}

- (void)gesturePasswordView:(JXGesturePasswordView *)gesturePasswordView
      didFinishDrawPassword:(NSString *)password
{
    if ([password length] <= 4) {
        [SVProgressHUD showErrorWithStatus:@"you have to make more than 4 Numbers"] ;
        return ;
    }
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults] ;
    NSString *gesPwd = [userDefaultes objectForKey:@"gesturePwd"] ;
    if ([password isEqualToString:gesPwd])
    {
        [SVProgressHUD showSuccessWithStatus:@"success"] ;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [gesturePasswordView removeFromSuperview] ;
            
            [self setupTable] ;
            self.btSch.hidden = NO ;
        }) ;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"password is wrong !"] ;
    }
}

#pragma mark --
- (void)changeTitleDisplay
{
    switch (self.pwdType)
    {
        case typeNone:
        {
            self.titleLb.text = @"All" ;
        }
            break;
        case typeWebsite:
        {
            self.titleLb.text = @"Website" ;
        }
            break;
        case typeCard:
        {
            self.titleLb.text = @"Card" ;
        }
            break;
        default:
            break;
    }
}

#pragma mark --
- (IBAction)userOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"all2user" sender:nil] ;
}

- (IBAction)typeItemOnClick:(id)sender
{
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"all"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        self.pwdType = typeNone ;
                                                        [self.table pullDownRefreshHeader] ;
                                                        [self changeTitleDisplay] ;
                                                    }] ;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"website"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        self.pwdType = typeWebsite ;
                                                        [self.table pullDownRefreshHeader] ;
                                                        [self changeTitleDisplay] ;
                                                    }] ;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"card"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        self.pwdType = typeCard ;
                                                        [self.table pullDownRefreshHeader] ;
                                                        [self changeTitleDisplay] ;
                                                    }] ;
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil] ;
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"CHOOSE TYPE"
                                                                       message:@"Choose the type, the list will be change ."
                                                                preferredStyle:UIAlertControllerStyleActionSheet] ;
    [alertCtrl addAction:action0] ;
    [alertCtrl addAction:action1] ;
    [alertCtrl addAction:action2] ;
    [alertCtrl addAction:action3] ;
    [self presentViewController:alertCtrl
                       animated:YES
                     completion:nil] ;
}

- (IBAction)addItemOnClick:(id)sender
{
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

static const int pageNumber = 20 ;

- (void)loadNew:(void(^)(void))endRefresh
{
//    if (self.dataList.count) {
//        endRefresh() ;
//        return ;
//    }
    
    int lastOneId = 0 ;
    NSArray *listBack = [PwdItem selectWhere:[self sqlWhereStringWithLastId:lastOneId]] ;
    self.dataList = listBack ;
    endRefresh() ;
}

- (void)loadMore:(void(^)(void))endRefresh
{
    int lastOneId = ((PwdItem *)[self.dataList lastObject]).pkid ;
    NSArray *listBack = [PwdItem selectWhere:[self sqlWhereStringWithLastId:lastOneId]] ;
    if (!listBack.count)
    {
        [SVProgressHUD showInfoWithStatus:@"no items ..."] ;
        endRefresh() ;
        return ;
    }
    
    NSMutableArray *templist = [self.dataList mutableCopy] ;
    [templist addObjectsFromArray:listBack] ;
    self.dataList = templist ;
    endRefresh() ;
}

- (NSString *)sqlWhereStringWithLastId:(int)lastOneId
{
    return !self.pwdType
    ?
    [NSString stringWithFormat:@"pkid > %d LIMIT %d",lastOneId,pageNumber]
    :
    [NSString stringWithFormat:@"pkid > %d AND typeOfPwdItem == %d LIMIT %d",lastOneId,(int)self.pwdType,pageNumber] ;
}

#pragma mark --
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
    cell.name.text = item.name ;
    
    cell.layer.transform = CATransform3DMakeScale(0.76, 0.76, 1) ;
    [UIView animateWithDuration:.25
                     animations:^{
                         cell.layer.transform = CATransform3DIdentity ;
                     }] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ListCell cellHeight] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchBar isFirstResponder]) {
        [self putSearchBt] ;
        return ;
    }
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
            [self.table pullDownRefreshHeaderInBackGround:YES] ;
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
