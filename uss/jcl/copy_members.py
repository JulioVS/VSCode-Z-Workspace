#! /usr/bin/env python3

import sys, getopt
from member_copy import member_copy

def main(argv):
    inputfile = ''
    outputfile = ''
    members = []

    opts, args = getopt.getopt(argv, "hi:o:m:", ["ifile=", "ofile="])

    for opt, arg in opts:
        if opt == '-h':
            print ('copy_member.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg
        elif opt in ("-m", "--member"):
            members.append(arg)

    print ('Input file is ', inputfile)
    print ('Output file is ', outputfile)
    print (f'Member List {members}')

    return_code = member_copy(inputfile, outputfile, members)

    if return_code == 0:
        print("Program ended")
    else:
        print("Program Abended")


if __name__ == "__main__":
    main(sys.argv[1:])
