//
//  ConnectedComponentResult.h
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#ifndef ConnectedComponentResult_h
#define ConnectedComponentResult_h

class ConnectedComponentResult {
public:
    int total_clusters;
    int **clusters_matrix;
    int *pixels_per_labels;
};

#endif /* ConnectedComponentResult_h */
