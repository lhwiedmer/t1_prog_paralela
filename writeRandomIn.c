#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define IN_NUM 125000

int main(int argv, char** argc) {
    const char* fileName = argc[1];
    srand(time(NULL));
    FILE *file = fopen(fileName, "w");
    for (size_t i = 0; i < IN_NUM; i++) {
        char random_char = 'a' + rand() % 26;
        fputc(random_char, file);
    }
    fclose(file);
}