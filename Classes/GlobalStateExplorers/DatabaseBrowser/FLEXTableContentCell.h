//
//  FLEXTableContentCell.h
//  UICatalog
//
//  Created by Peng Tao on 15/11/24.
//  Copyright © 2015年 f. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLEXTableContentCell;
@protocol FLEXTableContentCellDatasource <NSObject>

- (NSInteger)numberColumnsForCell;
- (CGFloat)heightForCell;
- (CGFloat)tableContentCell:(FLEXTableContentCell *)cell widthForntCellInColumn:(NSInteger)column;

@end

@interface FLEXTableContentCell : UITableViewCell

@property (nonatomic, strong)NSArray *labels;

@property (nonatomic, weak)id<FLEXTableContentCellDatasource> dataSource;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                           height:(CGFloat)height
                   withDataSource:(id<FLEXTableContentCellDatasource>)dataSource;

@end
