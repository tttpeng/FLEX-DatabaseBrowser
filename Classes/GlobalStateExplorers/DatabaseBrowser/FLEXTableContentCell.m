//
//  FLEXTableContentCell.m
//  UICatalog
//
//  Created by Peng Tao on 15/11/24.
//  Copyright © 2015年 f. All rights reserved.
//

#import "FLEXTableContentCell.h"
#import "FLEXMultiColumnTableView.h"

@interface FLEXTableContentCell ()

@end

@implementation FLEXTableContentCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.frame];
    self.textlabel = label;
    [self.contentView addSubview:label];
  }
  return self;
}

@end
