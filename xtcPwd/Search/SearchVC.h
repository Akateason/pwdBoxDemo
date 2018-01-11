//
//  SearchVC.h
//  
//
//  Created by teason23 on 2017/12/27.
//

#import "RootCtrl.h"

@protocol SearchVCDelegate <NSObject>
- (void)searchConfirmAndGoto:(id)item ;
@end

@interface SearchVC : RootCtrl
@property (weak,nonatomic) id <SearchVCDelegate> delegate ;
@property (weak, nonatomic) IBOutlet UIView *topBackView ;
@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@end
