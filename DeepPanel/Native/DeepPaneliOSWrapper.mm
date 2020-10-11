//
//  DeepPaneliOSWrapper.m
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeepPaneliOSWrapper.h"
#import "deep-panel-ios.hpp"

@implementation DeepPaneliOSWrapper

- (NSArray *)mapDeepPanelResultToRawPanels:(DeepPanelResult)result {
    NSMutableArray *rawPanels = [NSMutableArray array];
    for (int i = 1; i < result.connected_components.total_clusters; i++)
    {
        Panel panel = result.panels[i];
        RawPanel *rawPanel = [[RawPanel alloc] init];
        rawPanel.top = panel.top;
        rawPanel.left = panel.left;
        rawPanel.bottom = panel.bottom;
        rawPanel.right = panel.right;
        [rawPanels addObject: rawPanel];
    }
    
    return rawPanels;
}

- (RawPanelsInfo *) extractPanelsInfo:(float *)prediction
                andScale:(float)scale
                andOriginalImageWidth:(int)originalImageWidth
                andOriginalImageHeigth:(int)originalImageHeight {
    DeepPanelResult result = extract_panels_info_native(prediction, scale, originalImageWidth, originalImageHeight);
    RawPanelsInfo *rawPanelsInfo = [[RawPanelsInfo alloc] init];
    rawPanelsInfo.connectedAreas = result.connected_components.clusters_matrix;
    rawPanelsInfo.panels = [self mapDeepPanelResultToRawPanels:result];
    return rawPanelsInfo;
}


@end
