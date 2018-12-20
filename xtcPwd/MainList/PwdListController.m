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
#import "XTColor+MyColors.h"
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
#import "AddVC.h"
#import "PwdTableViewHandler.h"
#import "AliPayViews.h"
#import "KeychainData.h"
#import "SetpasswordViewController.h"
#import <XTBase/XTBase.h>
#import <ReactiveObjC.h>
#import "BaiduWebVC.h"


@interface PwdListController () <UINavigationControllerDelegate,FilterDelegate,AddVCDelegate,SearchVCDelegate,UITableViewXTReloaderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btAdd;
@property (weak, nonatomic) IBOutlet UITableView *table ;
@property (nonatomic,copy) NSArray *dataList ;
@property (nonatomic) TypeOfPwdItem pwdType ;
@property (strong, nonatomic) PwdTableViewHandler *tableHandler ;
@end

@implementation PwdListController

#pragma mark - SearchVCDelegate <NSObject>

- (void)searchConfirmAndGoto:(PwdItem *)item {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __block NSUInteger index = 0 ;
        [self.dataList enumerateObjectsUsingBlock:^(PwdItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:item.name]) {
                index = idx ;
                *stop = YES ;
            }
        }] ;
        
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES] ;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.table selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone] ;
            [self.tableHandler tableView:self.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]] ;
        }) ;
         
    }) ;
    
}

#pragma mark - AddVCDelegate <NSObject>

- (void)addPwdItem:(TypeOfPwdItem)type {
    [self performSegueWithIdentifier:@"list2add" sender:@(type)] ;
}

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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table xt_loadNewInfo] ;
    });
    
}

#pragma mark - life

- (void)viewDidLoad {
    
    [[self.testBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        BaiduWebVC *webVC = [BaiduWebVC newWithSchName:[@"好的" URLEncodedString] photoSelected:^(NSString * _Nonnull imgUrlStr) {
            NSLog(@"%@",imgUrlStr) ;
        }] ;
        
        [self.navigationController pushViewController:webVC animated:YES] ;
        
    }] ;
    
    
    [super viewDidLoad] ;
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    self.fd_prefersNavigationBarHidden = YES ;
    
    [[FilterCondition sharedSingleton] setup] ;
    
    [self setupUIs] ;
    [self setupTable] ;
    [self pwdSetup] ;
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"AddFinishNote" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.table xt_loadNewInfoInBackGround:YES] ;
    }] ;
    
    [[[NSNotificationCenter defaultCenter]
      rac_addObserverForName:@"NoteEditDone" object:nil]
     subscribeNext:^(NSNotification * _Nullable noti) {
         @strongify(self)

         PwdItem *item = noti.object ;
         NSMutableArray *tmplist = [self.dataList mutableCopy] ;
         [self.dataList enumerateObjectsUsingBlock:^(PwdItem *aItem, NSUInteger idx, BOOL * _Nonnull stop) {
             if (aItem.pkid == item.pkid) {
                 [tmplist replaceObjectAtIndex:idx withObject:item] ;
                 self.dataList = tmplist ;
                 [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade] ;
                 *stop = YES ;
             }
         }] ;
         
     }] ;
}

- (void)pwdSetup {
    BOOL isSave = [KeychainData isSave]; //是否有保存
    if (isSave) {
        SetpasswordViewController *setpass = [[SetpasswordViewController alloc] init];
        setpass.string = @"验证密码";
        [self presentViewController:setpass animated:YES completion:nil];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"Set your open password first"] ;
    }
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
    self.view.backgroundColor = [XTColor xt_main] ;
    [self.btUser setImage:[[UIImage imageNamed:@"user"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
    [self.btAdd setImage:[[UIImage imageNamed:@"add"] imageWithTintColor:[XTColor xt_main]] forState:0] ;
    [self.btSearch setImage:[[UIImage imageNamed:@"searchBt"] imageWithTintColor:[UIColor whiteColor]] forState:0] ;
}

- (void)setupTable {
    self.tableHandler = [[PwdTableViewHandler alloc] initWithCtrller:self] ;
    
    self.table.delegate     = self.tableHandler ;
    self.table.dataSource   = self.tableHandler ;
    self.table.xt_Delegate  = self ;
    self.table.mj_footer = nil ;
    self.table.backgroundColor = [XTColor xt_bg] ; // [UIColor whiteColor] ;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.table xt_setup];
    [self.table xt_loadNewInfoInBackGround:YES] ;
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
}

#pragma mark - util

- (NSString *)sqlWhereString {
    
    NSString *orderBy = @"pinyin" ;
    switch ([FilterCondition sharedSingleton].sortByType) {
        case sortByType_spell: orderBy = @"pinyin" ; break;
        case sortByType_time: orderBy = @"xt_updateTime" ; break;
        case sortByType_read: orderBy = @"readCount" ; break;
        default:
            break;
    }
    
    NSString *ascOrDesc = [FilterCondition sharedSingleton].isAscOrDesc ? @"ASC" : @"DESC" ;
    
    NSString *resultSql = !self.pwdType
    ?
    STR_FORMAT(@"SELECT * FROM PwdItem ORDER BY %@ %@",orderBy,ascOrDesc)
    :
    STR_FORMAT(@"SELECT * FROM PwdItem WHERE typeOfPwdItem == %d ORDER BY %@ %@",(int)self.pwdType,orderBy,ascOrDesc) ;
    
    NSLog(@"refresh sql: %@",resultSql);
    return resultSql;
}

#pragma mark - table

- (void)tableView:(RootTableView *)table loadNew:(void (^)(void))endRefresh
{
    NSArray *listBack = [PwdItem xt_findWithSql:[self sqlWhereString]] ;
    sleep(1) ;
    self.dataList = listBack ;
    endRefresh() ;
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
    else return nil ;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"list2detail"]) {
        DetailViewController *detailVC = [segue destinationViewController] ;
        [detailVC selectedIndexInHomeList:[sender integerValue]
                                     list:self.dataList] ;
    }
    else if ([segue.identifier isEqualToString:@"all2user"]) {
        UserViewController *userVC = [segue destinationViewController] ;
        userVC.delegate = self ;
    }
    else if ([segue.identifier isEqualToString:@"home2add"]) {
        AddVC *addVC = [segue destinationViewController] ;
        addVC.delegate = self ;
    }
    else if ([segue.identifier isEqualToString:@"list2add"]) {
        EditViewController *editVC = [segue destinationViewController] ;
        editVC.typeWillBeAdd = [sender intValue] ;
    }
    else if ([segue.identifier isEqualToString:@"home2search"]) {
        SearchVC *searchvc = [segue destinationViewController] ;
        searchvc.delegate = self ;
    }
}

@end
