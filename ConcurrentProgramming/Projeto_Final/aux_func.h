#ifndef _AUX_FUNC_
#define _AUX_FUNC_
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

// DATA --------------------
struct ride {
    char *name;
    int minimum_age;
    int best_suited_up_to;
    int riding_time;
};
typedef struct ride ride_t;
const char *ride_name[6] = {"Drop Tower", "Ferris Wheel", "Water Slide", "Kamikazi", "Bump Car", "Roller Coaster"};
// -------------------------

void build_struct(ride_t**, size_t);
void fill_struct(ride_t**, char**);

#endif