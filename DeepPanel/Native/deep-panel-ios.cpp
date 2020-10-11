//
//  deep-panel-ios.cpp
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#include "deep-panel-ios.hpp"

int matrix_size = 224;

int **map_prediction_to_labeled_matrix(float *prediction) {
    int **labeled_matrix = new int *[matrix_size];
    for (int i = 0; i < matrix_size; i++) {
        labeled_matrix[i] = new int[matrix_size];
        for (int j = 0; j < matrix_size; j++) {
            float red = prediction[i + j + 0];
            float green = prediction[i + j + 1];
            float blue = prediction[i + j + 2];
            if (red > green && red > blue) {
                labeled_matrix[i][j] = 1;
            } else if (green > red && green > blue) {
                labeled_matrix[i][j] = 2;
            } else {
                labeled_matrix[i][j] = 3;
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
