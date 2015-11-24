//
//  PTTableContentViewController.m
//  PTDatabaseReader
//
//  Created by Peng Tao on 15/11/23.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import "FLEXTableContentViewController.h"
#import "FLEXMultiColumnTableView.h"


@interface FLEXTableContentViewController ()<FLEXMultiColumnTableViewDataSource>

@property (nonatomic, strong)FLEXMultiColumnTableView *multiColumView;

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
    _multiColumView = [[FLEXMultiColumnTableView alloc] initWithFrame:
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
    }
    else {
      _multiColumView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    [self.view setNeedsLayout];
  } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.multiColumView reloadData];
  
}
- (NSInteger)numberOfColumnsInTableView:(FLEXMultiColumnTableView *)tableView
{
  return self.columnsArray.count;
}
- (NSInteger)numberOfRowsInTableView:(FLEXMultiColumnTableView *)tableView
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
  if (self.contensArray.count > row) {
    NSDictionary *dic = self.contensArray[row];
    if (self.contensArray.count > column) {
      return [NSString stringWithFormat:@"%@",[dic objectForKey:self.columnsArray[column]]];
    }
  }
  return @"xxxxx";
}

- (NSArray *)contentAtRow:(NSInteger)row
{
  if (self.contensArray.count > row) {
    NSDictionary *dic = self.contensArray[row];
    return  [dic allValues];
  }
  return nil;
}
- (CGFloat)multiColumnTableView:(FLEXMultiColumnTableView *)tableView
      heightForContentCellInRow:(NSInteger)row
{
  return 40;
}

- (CGFloat)multiColumnTableView:(FLEXMultiColumnTableView *)tableView
    widthForContentCellInColumn:(NSInteger)column
{
  return 100;
}


- (CGFloat)heightForTopHeaderInTableView:(FLEXMultiColumnTableView *)tableView
{
  return 50;
}

- (CGFloat)WidthForLeftHeaderInTableView:(FLEXMultiColumnTableView *)tableView
{
  NSString *str = [NSString stringWithFormat:@"%d",self.contensArray.count];
  NSDictionary *attrs = @{@"NSFontAttributeName":[UIFont systemFontOfSize:17.0]};
  CGSize size =   [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 14)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attrs context:nil].size;
  return size.width + 20;
}


@end
