#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

void swap(int *a, int *b) {
  int t = *a;
  *a = *b;
  *b = t;
}

int partition(int array[], int first, int last) {
  int pivot = array[last];
  int split = first;
  for (int i = first; i < last; i++)
    if (array[i] < pivot)
      swap(&array[i], &array[split++]);
  swap(&array[split], &array[last]);
  return split;
}

void quick_sort(int array[], int low, int high) {
  if (low < high) {
    int p = partition(array, low, high);
    quick_sort(array, low, p - 1);
    quick_sort(array, p + 1, high);
  }
}

int main() {
  char input_filename[] = "../../inputs/day1.txt";
  FILE *fp;
  int rows = 0;
  fp = fopen(input_filename, "r");
  if (fp == NULL) {
    printf("Could not open file %s", input_filename);
    return 0;
  }

  // Count rows
  char c;
  for (c = getc(fp); c != EOF; c = getc(fp))
    if (c == '\n')
      rows += 1;
  rewind(fp);

  // Read file into arrays
  int *list1 = malloc(sizeof(int) * rows);
  int *list2 = malloc(sizeof(int) * rows);
  char line_buffer[20];
  char *endptr;

  int i = 0;
  while (fgets(line_buffer, 20, fp) != NULL) {
    list1[i] = (int)strtol(line_buffer, &endptr, 10);
    list2[i] = (int)strtol(endptr, &endptr, 10);
    i++;
  }

  // part 1
  quick_sort(list1, 0, rows - 1);
  quick_sort(list2, 0, rows - 1);

  long part1 = 0;
  for (int i = 0; i < rows; i++) {
    part1 += labs(list1[i] - list2[i]);
  }
  printf("Part 1: %ld\n", part1);

  // part 2
  long part2 = 0;
  int key;
  int l2_idx = 0;
  int l2_count = 0;
  for (int i = 0; i < rows; i++) {
    key = list1[i];
    while (list2[l2_idx] < key) {
      l2_idx++;
    }
    if (list2[l2_idx] == key) {
      while (list2[l2_idx] == key) {
        l2_idx++;
        l2_count++;
      }
      part2 += key * l2_count;
    }
    l2_count = 0;
  }
  printf("Part 2: %ld", part2);

  assert(part1 == 1651298);
  assert(part2 == 21306195);

  // Part 1: 1651298
  // Part 2: 21306195
  free(list1);
  free(list2);
  fclose(fp);
}
