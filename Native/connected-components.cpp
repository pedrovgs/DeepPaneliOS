//
//  connected-components.cpp
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

#include <stdio.h>
#include <cstdlib>
#include <cassert>
#include "connected-components.hpp"

/* Implementation of Union-Find Algorithm and Hoshen Kopelman Algorithm (aka Connected Component Labeling).
 * You can find the reference implementation here: https://www.ocf.berkeley.edu/~fricke/projects/hoshenkopelman/hk.c.
 * Useful info about this algorithm can be found here: https://www.ocf.berkeley.edu/~fricke/projects/hoshenkopelman/hoshenkopelman.html*/

/* The 'labels' array has the meaning that labels[x] is an alias for the label x; by
   following this chain until x == labels[x], you can find the canonical name of an
   equivalence class.  The labels start at one; labels[0] is a special value indicating
   the highest label already used. */

int *labels;
int n_labels = 0;     /* length of the labels array */

/*  uf_find returns the canonical label for the equivalence class containing x */

int uf_find(int x) {
    int y = x;
    while (labels[y] != y)
        y = labels[y];

    while (labels[x] != x) {
        int z = labels[x];
        labels[x] = y;
        x = z;
    }
    return y;
}

/*  uf_union joins two equivalence classes and returns the canonical label of the resulting class. */

int uf_union(int x, int y) {
    return labels[uf_find(x)] = uf_find(y);
}

/*  uf_make_set creates a new equivalence class and returns its label */

int uf_make_set(void) {
    labels[0]++;
    assert(labels[0] < n_labels);
    labels[labels[0]] = labels[0];
    return labels[0];
}

/*  uf_intitialize sets up the data structures needed by the union-find implementation. */

void uf_initialize(int max_labels) {
    n_labels = max_labels;
    labels = static_cast<int *>(calloc(n_labels, sizeof(int)));
    labels[0] = 0;
}

/*  uf_done frees the memory used by the union-find data structures */

void uf_done(void) {
    n_labels = 0;
    free(labels);
    labels = 0;
}

/* End Union-Find implementation */

#define max(a, b) (a>b?a:b)

/* Hoshen Kopelman algorithm implementation. Label the clusters in "matrix".  Return the total number of clusters found. */

ConnectedComponentResult find_components(int **matrix, int m, int n) {

    uf_initialize(m * n / 2);

    /* scan the matrix */

    for (int j = 0; j < n; j++)
        for (int i = 0; i < m; i++)
            if (matrix[i][j]) {                        // if occupied ...

                int up = (i == 0 ? 0 : matrix[i - 1][j]);    //  look up
                int left = (j == 0 ? 0 : matrix[i][j - 1]);  //  look left

                switch (!!up + !!left) {

                    case 0:
                        matrix[i][j] = uf_make_set();      // a new cluster
                        break;

                    case 1:                              // part of an existing cluster
                        matrix[i][j] = max(up, left);       // whichever is nonzero is labelled
                        break;

                    case 2:                              // this site binds two clusters
                        matrix[i][j] = uf_union(up, left);
                        break;
                }

            }

    /* apply the relabeling to the matrix */

    /* This is a little bit sneaky.. we create a mapping from the canonical labels
       determined by union/find into a new set of canonical labels, which are
       guaranteed to be sequential. */

    int *new_labels = static_cast<int *>(calloc(n_labels,
                                                sizeof(int))); // allocate array, initialized to zero
    int *pixels_per_label = static_cast<int *>(calloc(n_labels,
                                                      sizeof(int))); // allocate array, initialized to zero
    for (int j = 0; j < n; j++)
        for (int i = 0; i < m; i++)
            if (matrix[i][j]) {
                int x = uf_find(matrix[i][j]);
                if (new_labels[x] == 0) {
                    new_labels[0]++;
                    new_labels[x] = new_labels[0];
                }
                int new_label_to_assign = new_labels[x];
                matrix[i][j] = new_label_to_assign;
                pixels_per_label[new_label_to_assign]++;
            }

    int total_clusters = new_labels[0];

    free(new_labels);
    uf_done();

    ConnectedComponentResult result;
    result.total_clusters = total_clusters;
    result.clusters_matrix = matrix;
    result.pixels_per_labels = pixels_per_label;
    return result;
}
