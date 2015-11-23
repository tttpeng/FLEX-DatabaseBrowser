//
//  PTMultiColumnTableView.h
//  PTMultiColumnTableViewDemo
//
//  Created by Peng Tao on 15/11/16.
//  Copyright © 2015年 Peng Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLEXPTMultiColumnTableView;
@protocol FLEXMultiColumnTableViewDataSource <NSObject>

@required


- (NSInteger)numberOfColumnsInTableView:(FLEXPTMultiColumnTableView *)tableView;
- (NSInteger)numberOfRowsInTableView:(FLEXPTMultiColumnTableView *)tableView;
- (NSString *)columnNameInColumn:(NSInteger)column;
- (NSString *)rowNameInRow:(NSInteger)row;
- (NSString *)contentAtColumn:(NSInteger)column row:(NSInteger)row;

- (CGFloat)multiColumnTableView:(FLEXPTMultiColumnTableView *)tableView widthForContentCellInColumn:(NSInteger)column;
- (CGFloat)multiColumnTableView:(FLEXPTMultiColumnTableView *)tableView heightForContentCellInRow:(NSInteger)row;
- (CGFloat)heightForTopHeaderInTableView:(FLEXPTMultiColumnTableView *)tableView;
- (CGFloat)WidthForLeftHeaderInTableView:(FLEXPTMultiColumnTableView *)tableView;

@end


@interface FLEXPTMultiColumnTableView : UIView

//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<FLEXMultiColumnTableViewDataSource>dataSource;

- (void)reloadData;


@end
