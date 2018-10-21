#include "aux_func.h"

void build_struct(ride_t **struct_pointer, size_t how_many) {
    struct_pointer = malloc(how_many * sizeof(ride_t));
}
void fill_struct(ride_t **struct_pointer, char** ride_name) {
    // for(int i=0; i<len(struct_pointer); i++){
    //     struct_pointer[i].name = malloc(sizeof(ride_name[(i%len(ride_name))]));
    //     strcpy(struct_pointer[i].name, ride_name[(i%len(ride_name))]);
    // }
}