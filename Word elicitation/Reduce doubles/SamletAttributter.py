import csv
import numpy as numpy
from collections import defaultdict

if __name__ == '__main__':
    with open("SamletAtrributter.csv") as i:
        input = i.read().strip()
    splittet = input.split(',')

    # print(splittet)
    splittet_lowercase = []
    for word in splittet:
        splittet_lowercase.append(word.lower())
    print(splittet)
    print(splittet_lowercase)

    attribute_list = []
    counter = []
    for attribute in splittet_lowercase:
        if attribute not in attribute_list:

            attribute_list.append(attribute)
            counter.append(1)
            index = attribute_list.index(attribute)
            # print(index)
        else:
            # print(attribute)
            index = attribute_list.index(attribute)
            # print(index)
            counter[index] = counter[index] + 1

    skaleksporteres = [attribute_list, counter]
    arr = numpy.array(skaleksporteres)
    # print(arr)
    arr = numpy.transpose(arr)
    print(arr[1][0])

    print(f'All categories {len(splittet)}, has been reduced to: {len(arr)}')
    # arr = arr[arr[:, 1].argsort()]
    # arr=numpy.flipud(arr)
    # print(arr)

    count_words = defaultdict(int)
    for word in splittet_lowercase:
        count_words[word] += 1
    print(count_words)
    print(f'All categories {len(splittet)}, has been reduced to: {len(count_words)}')

    with open('SamletAtrributter_Sorted.csv', 'w') as f:
        csv_writer = csv.writer(f)
        csv_writer.writerow(['Attribut', 'Counter'])

        csv_writer.writerows(arr)
        # Funktionen laver et csv datastruktur og skriver navnene på rows og lægger så alle rows ind

    # open file for writing, "w" is writing
    w = csv.writer(open("Aleksmetode.csv", "w"))

    # loop over dictionary keys and values
    for key, val in count_words.items():
        # write every key and value to file
        w.writerow([key, val])

        