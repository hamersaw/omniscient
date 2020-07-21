#!/bin/python3

import argparse
import sys

def next_record(file):
    # read line from file
    line = file.readline()        
    if not line:
        return None

    # parse record
    array = line.rstrip().split(',')
    record = []
    for value in array:
        record.append(float(value))

    return record

def next_record_all(files):
    data = []
    for file in files:
        # parse next record
        record = next_record(file)
        if record == None:
            return None

        # add record to data
        data.append(record)

    return data

if __name__ == '__main__':
    # parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('files', metavar='FILES', nargs='+',
        help='list of input csv files.')
    args = parser.parse_args()

    # iterate over all files in arg.files
    files = []
    headerstr = ''
    for filename in args.files:
        # open input and output files
        file = open(filename, 'r')

        # validate file header
        line = file.readline()
        if not headerstr:
            headerstr = line
        else:
            if line != headerstr:
                print('headers do not match')
                sys.exit(1)

        # add file to list
        files.append(file)

    # read first record from each file
    data = next_record_all(files)

    # sync reader timestamps
    max_timestamp = 0.0
    for record in data:
        if max_timestamp < record[0]:
            max_timestamp = record[0]

    for i, record in enumerate(data):
        while record[0] < max_timestamp:
            new_record = next_record(files[i])
            for j in range(len(record)):
                record[j] = new_record[j]

    #print(data)
    print('record,' + headerstr.rstrip())
    aggregate_values = []

    record_num = 0
    while True:
        # process data
        aggregate_values.clear()
        for record in data:
            if len(aggregate_values) == 0:
                # if aggregate_values is empty -> populate
                for value in record:
                    aggregate_values.append(value)
            else:
                # incrememt values (skipping timestamp)
                for j, value in enumerate(record[1:]):
                    aggregate_values[j+1] += value

        # print line of aggregate values
        line = str(record_num) + ',' + str(int(aggregate_values[0]))
        for value in aggregate_values[1:]:
            line += ',' + str(value)
        print(line)

        # retrieve next record from each file
        data = next_record_all(files)
        record_num += 1
        if data == None:
            break
    
    # close all files
    for file in files:
        file.close()
