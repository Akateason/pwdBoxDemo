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
#import "ReactiveObjC.h"
#import "SVProgressHUD.h"
#import "UIColor+AllColors.h"

@interface PwdListController () <UITableViewDelegate,UITableViewDataSource,RootTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *typeItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItem;
@property (weak, nonatomic) IBOutlet RootTableView *table;

@property (nonatomic,copy) NSArray *dataList ;
@property (nonatomic) TypeOfPwdItem pwdType ;
@end

@implementation PwdListController

#pragma mark --
- (void)viewDidLoad
{
    [PwdItem createTable] ;
    
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.
    self.table.delegate     = self ;
    self.table.dataSource   = self ;
    self.table.xt_Delegate  = self ;
    [self.table pullDownRefreshHeaderInBackGround:YES] ;
    self.table.backgroundColor = [UIColor xt_d_red] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
- (void)changeTitleDisplay
{
    switch (self.pwdType)
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
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"current TYPE"
                                                                       message:@"choose a type"
                                                                preferredStyle:UIAlertControllerStyleActionSheet] ;
    [alertCtrl addAction:action0] ;
    [alertCtrl addAction:action1] ;
    [alertCtrl addAction:action2] ;
    [alertCtrl addAction:action3] ;
    [self presentViewController:alertCtrl animated:YES completion:nil] ;
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
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"ADD an item"
                                                                       message:@"choose a type"
                                                                preferredStyle:UIAlertControllerStyleActionSheet] ;
    [alertCtrl addAction:action1] ;
    [alertCtrl addAction:action2] ;
    [alertCtrl addAction:action3] ;
    [self presentViewController:alertCtrl animated:YES completion:nil] ;
}


#pragma mark --
static const int pageNumber = 10 ;
- (void)loadNew:(void(^)(void))endRefresh
{
    int lastOneId = 0 ;
    NSArray *listBack = [PwdItem selectWhere:[self sqlWhereStringWithLastId:lastOneId]] ;
    self.dataList = listBack ;
    endRefresh() ;
}

- (void)loadMore:(void(^)(void))endRefresh
{
    int lastOneId = ((PwdItem *)[self.dataList lastObject]).pkid ;
    NSArray *listBack = [PwdItem selectWhere:[self sqlWhereStringWithLastId:lastOneId]] ;
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
}


@end
