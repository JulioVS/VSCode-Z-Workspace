import sys, getopt
from member_copy import member_copy

def main(argv):
   inputfile = ''
   outputfile = ''
   members = []
   opts, args = getopt.getopt(argv,"hi:o:m:",["ifile=","ofile="])
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

if __name__ == "__main__":
   main(sys.argv[1:])
   