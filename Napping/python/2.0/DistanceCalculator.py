import csv
import math
import pandas as pd


def importGroup(Name):
    data = pd.read_csv(Name)
    # Extract x and y columns from the DataFrame
    x_values = data['x']
    y_values = data['y']
    GroupPoints = [x_values, y_values]
    return GroupPoints


def printXYinGroups(Group1, Group2, Group3, Group4, Group5, Group6):
    Groups = [Group1, Group2, Group3, Group4, Group5, Group6]
    print("X,Y")
    for i in range(0, 6):
        print(f'{Groups[i][0][1]},{Groups[i][1][1]}')


# Function to calculate Euclidean distance between two points
def calculate_distance(point1, point2):
    x1, y1 = point1
    x2, y2 = point2
    distance = math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
    return distance


def SaveToCsv(bigTable, name):
    with open(f"BigTables/{name}.csv", 'w', newline='') as csvfile:
        # Create a CSV writer object
        csv_writer = csv.writer(csvfile)
        # Write the points to the CSV file
        csv_writer.writerows(bigTable)


def CalculateDistanceForGroup(Group, number):
    bigTable = []
    for i in range(len(Group[0])):
        point1x = Group[0][i]
        point1y = Group[1][i]
        point1 = [point1x, point1y]
        # print(point1)
        distances = []
        for j in range(len(Group[0])):
            point2 = [Group[0][j], Group[1][j]]
            distance = calculate_distance(point1, point2)
            # print(f'Distance from {point1} to {point2} is = {distance}')
            distance = format(distance,".2f")
            distance = str(distance).replace(".", ",")
            distances.append(distance)
        bigTable.append(distances)
    # print(bigTable)
    SaveToCsv(bigTable, f"Group{number}")
    return bigTable


def MeanValues(Tables, name):
    HUGETABLE = []
    for i in range(len(Tables[0][0])):
        Column = []
        for j in range(len(Tables[0][0])):
            values = [Tables[0][i][j], Tables[1][i][j], Tables[2][i][j]]
            mean_value = sum(values) / len(values)
            Column.append(mean_value)
        HUGETABLE.append(Column)
    SaveToCsv(HUGETABLE, f"{name}")
    return HUGETABLE

def MeanValues_2(Tables, name):
    HUGETABLE = []
    for i in range(len(Tables[0][0])):
        Column = []
        for j in range(len(Tables[0][0])):
            value1 = Tables[0][i][j]
            value2 = Tables[1][i][j]
            value1 = float(value1)
            value2 = float(value2)
            values = [Tables[0][i][j], Tables[1][i][j]]
            values = [value1,value2]
            mean_value = sum(values) / len(values)
            Column.append(mean_value)
        HUGETABLE.append(Column)
    SaveToCsv(HUGETABLE, f"{name}")
    return HUGETABLE

def Standardization(Table):
    StandardizedTable = Table
    # Max er 30, Min er -30
    min = -30
    max = 30
    # zi = (xi – min(x)) / (max(x) – min(x)) *100
    for i in range(len(Table[0])):
        Column = []
        for j in range(len(Table[0])):
            value = Table[i][j]
            normalized = ((value - min) / (max - min))
            print(normalized)
            StandardizedTable[i][j] = normalized
    # Producerer lige nu værdier over 1 og der kommer 0.5 hvor der skal komme 0.
    # Funktionen skal ændres så de svinger mellem -1 og 1. Det giver bedre mening så.

    return StandardizedTable


if __name__ == '__main__':
    Group1 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/Groups/Group1.csv")
    Group2 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/Groups/Group2.csv")
    Group3 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/Groups/Group3.csv")
    Group4 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/Groups/Group4.csv")
    Group5 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/Groups/Group5.csv")
    Group6 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/Groups/Group6.csv")
    # Group1[0][0] = x og Group1[1][0] = y
    # printXYinGroups(Group1,Group2,Group3,Group4,Group5,Group6)

    Bigtable1 = CalculateDistanceForGroup(Group1, 1)
    Bigtable2 = CalculateDistanceForGroup(Group2, 2)
    Bigtable3 = CalculateDistanceForGroup(Group3, 3)
    Bigtable4 = CalculateDistanceForGroup(Group4, 4)
    Bigtable5 = CalculateDistanceForGroup(Group5, 5)
    Bigtable6 = CalculateDistanceForGroup(Group6, 6)
    exit()
    Test1 = [Bigtable1, Bigtable2, Bigtable3]
    Test2 = [Bigtable4, Bigtable5, Bigtable6]
    HugeTable1 = MeanValues(Test1, "MeanTest1")
    HugeTable2 = MeanValues(Test2, "MeanTest2")


    # Open the CSV file and read its contents into a list
    with open('/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/BigTables/MeanTest1_CutDown.csv', 'r') as file:
        # Specify the delimiter used in your DSV file, e.g., ',' for comma-separated values
        delimiter = ','
        # Create a CSV reader object
        reader = csv.reader(file, delimiter=delimiter)
        # Read the rows from the CSV file into a list
        Test1 = list(reader)
    with open('/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/BigTables/MeanTest2_CutDown.csv', 'r') as file:
        # Specify the delimiter used in your DSV file, e.g., ',' for comma-separated values
        delimiter = ','
        # Create a CSV reader object
        reader = csv.reader(file, delimiter=delimiter)
        # Read the rows from the CSV file into a list
        Test2 = list(reader)
        print(Test2)

    # Now, 'data' contains the contents of your DSV file in a list with the original structure
    # Each row from the file is a sublist within the 'data' list
    #Test1 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/BigTables/MeanTest1_CutDown.csv")
    #Test2 = importGroup("/Users/jeppegivskud/PycharmProjects/P7-Beer/Napping/BigTables/MeanTest2_CutDown.csv")

    HugeTables=[Test1,Test2]
    MEGAHUGETABLE = MeanValues_2(HugeTables, "MEGAHUGETABLE")

    #Standardization(HugeTable1)
