//
//  deep-panel-ios.cpp
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#include "deep-panel-ios.hpp"

int matrix_size = 224;

int coordinateToIndex(int i, int j, int z) {
    // j and i indexes order is changed on purpose because the original matrix
    // is rotated when reading the values.
    return j * 224 * 3 + i * 3 + z;
}

int **map_prediction_to_labeled_matrix(float *prediction) {
    int **labeled_matrix = new int *[matrix_size];
    for (int i = 0; i < matrix_size; i++) {
        labeled_matrix[i] = new int[matrix_size];
        for (int j = 0; j < matrix_size; j++) {
            float red = prediction[coordinateToIndex(i, j, 0)];
            float green = prediction[coordinateToIndex(i, j, 1)];
            float blue = prediction[coordinateToIndex(i, j, 2)];
            if (red > green && red > blue) {
                labeled_matrix[i][j] = 0;
            } else if (green > red && green > blue) {
                // The original label should be 1 but we need this value to be 0
                // because the ccl algorithm uses 0 and 1 as values. 0 is used for the background.
                labeled_matrix[i][j] = 0;
            } else {
                // The original label should be 1 but we need this value to be 0
                // because the ccl algorithm uses 0 and 1 as values. 1 is used for the content.
                labeled_matrix[i][j] = 1;
            }
        }
    }
    return labeled_matrix;
}

DeepPanelResult extract_panels_info_native(float *prediction, float scale, int original_image_width, int original_image_height) {
    int **labeled_matrix = map_prediction_to_labeled_matrix(prediction);
    return extract_panels_info(labeled_matrix,
                        matrix_size,
                        matrix_size,
                        scale,
                        original_image_width,
                        original_image_height);
}
