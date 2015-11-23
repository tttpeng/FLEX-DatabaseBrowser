//
//  PTTableContentViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/23.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "FLEXTableContentViewController.h"
#import "FLEXPTMultiColumnTableView.h"


@interface FLEXTableContentViewController ()<FLEXMultiColumnTableViewDataSource>

@property (nonatomic, strong)FLEXPTMultiColumnTableView *multiColumView;

@end

@implementation FLEXTableContentViewController


- (instancetype)init
{
  self = [super init];
  if (self) {
    
    CGRect rectStatus = [UIApplication sharedApplication].statusBarFrame;
    CGFloat y = 64;
    if (rectStatus.size.height == 0) {
      y = 32;
    }
    _multiColumView = [[FLEXPTMultiColumnTableView alloc] initWithFrame:
                       CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y)];
    
    _multiColumView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _multiColumView.backgroundColor  = [UIColor whiteColor];
    _multiColumView.dataSource       = self;
    self.view.backgroundColor        = [UIColor redColor];
    [self.view addSubview:_multiColumView];
  }
  return self;
}



- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
              withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
  [super willTransitionToTraitCollection:newCollection
               withTransitionCoordinator:coordinator];
  [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
    if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {

      _multiColumView.frame = CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height - 32);
      
      //To Do: modify something for compact vertical size
    } else {
      _multiColumView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
      NSLog(@"--->222");
      //To Do: modify something for other vertical size
    }
    [self.view setNeedsLayout];
  } completion:nil];
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//  CGRect rectNav = self.navigationController.navigationBar.frame;
//  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//  
//}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.multiColumView reloadData];
  
}
- (NSInteger)numberOfColumnsInTableView:(FLEXPTMultiColumnTableView *)tableView
{
  return self.columnsArray.count;
}
- (NSInteger)numberOfRowsInTableView:(FLEXPTMultiColumnTableView *)tableView
{
  return self.contensArray.count;
}


- (NSString *)columnNameInColumn:(NSInteger)column
{
    NSLog(@"----->%@",self.columnsArray);
    return self.columnsArray[column];
}


- (NSString *)rowNameInRow:(NSInteger)row
{
  
  return [NSString stringWithFormat:@"%ld",(long)row];
  
}
- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row
{
  NSLog(@"12----->%@",self.columnsArray);
  if (self.contensArray.count > row) {
    NSDictionary *dic = self.contensArray[row];
    if (self.contensArray.count > column) {
      return [NSString stringWithFormat:@"%@",[dic objectForKey:self.columnsArray[column]]];
    }
  }
  return @"xxxxx";
}

- (CGFloat)multiColumnTableView:(FLEXPTMultiColumnTableView *)tableView
      heightForContentCellInRow:(NSInteger)row
{
  return 40;
}

- (CGFloat)multiColumnTableView:(FLEXPTMultiColumnTableView *)tableView
    widthForContentCellInColumn:(NSInteger)column
{
  return 100;
}


- (CGFloat)heightForTopHeaderInTableView:(FLEXPTMultiColumnTableView *)tableView
{
  return 50;
}

- (CGFloat)WidthForLeftHeaderInTableView:(FLEXPTMultiColumnTableView *)tableView
{
  return 80;
}


@end
