//
//  PNLineChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

extern NSInteger const kChartMargin;
extern NSInteger const kXLabelMargin;
extern NSInteger const kYLabelMargin;
extern NSInteger const kYLabelHeight;

@interface PNLineChart : UIView

@property (nonatomic) UIColor *strokeColor;

- (void)drawLineChartWithxLabels:(NSArray *)xLabels
                         yValues:(NSArray *)yValues;

@end
