#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

int acceptable_part1(const int numbers[], int count) {
  int increasing = (numbers[1] > numbers[0]);
  int delta;

  for (int i = 1; i < count; i++) {
    delta = abs(numbers[i] - numbers[i - 1]);
    if (increasing && (numbers[i] < numbers[i - 1]) ||
        !increasing && (numbers[i] > numbers[i - 1]) || delta < 1 ||
        delta > 3) {
      return 0;
    }
  }
  return 1;
}

int acceptable_part2(const int numbers[], int count, int skip) {
  int comparison = (skip == 0) ? numbers[1] : numbers[0];
  int first_check = (skip < 2) ? 2 : 1;
  int current = numbers[first_check];
  int increasing = (current > comparison);
  int delta;

  for (int i = first_check; i < count; i++) {
    if (i == skip)
      continue;

    current = numbers[i];
    delta = abs(current - comparison);
    if (increasing && (current < comparison) ||
        !increasing && (current > comparison) || delta < 1 || delta > 3) {
      if (skip < count - 1) {
        return acceptable_part2(numbers, count, skip + 1);
      } else {
        return 0;
      }
    }
    comparison = current;
  }
  return 1;
}

int parse_string_of_ints(const char line_buffer[], int numbers[]) {
  char *end_pointer = (char *)line_buffer;
  int i = 0;
  while (*end_pointer != '\n') {
    numbers[i] = strtol(end_pointer, &end_pointer, 10);
    i++;
  }
  return i;
}

int main() {
  char input_filename[] = "../../inputs/day2.txt";
  FILE *fp;
  fp = fopen(input_filename, "r");
  if (fp == NULL) {
    printf("Could not open file %s", input_filename);
    return 0;
  }
  int acceptable = 0;
  int part1 = 0;
  int part2 = 0;

  char line_buffer[30];
  int numbers[10];
  int c_numbers;

  while (fgets(line_buffer, 30, fp) != NULL) {
    c_numbers = parse_string_of_ints(line_buffer, numbers);
    acceptable = acceptable_part1(numbers, c_numbers);

    part1 += acceptable;
    if (acceptable == 1) {
      part2 += acceptable;
    } else {
      part2 += acceptable_part2(numbers, c_numbers, 0);
    }
  }

  printf("Part1: %d\n", part1);
  printf("Part2: %d\n", part2);
  assert(part1 == 442);
  assert(part2 == 493);
  fclose(fp);
}
