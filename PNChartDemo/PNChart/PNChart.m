//
//  PNChart.m
//  PNChart
//
//  Created by kevin on 10/3/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNChart.h"

@implementation PNChart

@synthesize xLabels = _xLabels;
@synthesize yValues = _yValues;
@synthesize lineChart = _lineChart;
@synthesize barChart = _barChart;
@synthesize type = _type;
@synthesize strokeColor = _strokeColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        self.type = PNLineType;
    }
    
    return self;
}

- (void)setUpChart{
	if (self.type == PNLineType) {
		self.lineChart = [[PNLineChart alloc]
                          initWithFrame:CGRectMake(0, 0,
                                                   self.frame.size.width,
                                                   self.frame.size.height)];
        [self.lineChart drawLineChartWithxLabels:self.xLabels yValues:self.yValues];
        [self.lineChart setBackgroundColor:[UIColor clearColor]];
        [self.lineChart setStrokeColor:self.strokeColor];
		[self addSubview:self.lineChart];
	} else if (self.type == PNBarType) {
		self.barChart = [[PNBarChart alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  self.frame.size.width,
                                                  self.frame.size.height)];
		self.barChart.backgroundColor = [UIColor clearColor];
		[self addSubview:self.barChart];
		[self.barChart setYValues:self.yValues];
		[self.barChart setXLabels:self.xLabels];
		[self.barChart setStrokeColor:self.strokeColor];
		[self.barChart strokeChart];
	}
}

- (void)strokeChart
{
	[self setUpChart];
}



@end
