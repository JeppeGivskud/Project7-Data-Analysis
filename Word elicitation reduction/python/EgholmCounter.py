import csv
import numpy as numpy

if __name__ == '__main__':
    with open("EgholmAttributes.csv") as i:
        input = i.read().strip()

    splittet = input.split('\n')
    splittet_lowercase=[]
    for word in splittet:
        splittet_lowercase.append(word.lower())

    attribute_list=[]
    counter=[]
    for attribute in splittet_lowercase:
        if attribute not in attribute_list:
            attribute_list.append(attribute)
            counter.append(1)
            index = attribute_list.index(attribute)
            #print(index)
        else:
            #print(attribute)
            index = attribute_list.index(attribute)
            #print(index)
            counter[index]=counter[index]+1

    skaleksporteres=[attribute_list,counter]
    arr = numpy.array(skaleksporteres)
    #print(arr)
    arr=numpy.transpose(arr)
    #print(arr)
    print(f'All categories {len(splittet)}, has been reduced to: {len(arr)}')
    arr = arr[arr[:, 1].argsort()]
    arr=numpy.flipud(arr)

    with open('EgholmAttributes_Sorted.csv', 'w') as f:
        csv_writer = csv.writer(f)
        csv_writer.writerow(['Attribut','Counter'])
        csv_writer.writerows(arr)
        #Funktionen laver et csv datastruktur og skriver navnene på rows og lægger så alle rows ind


