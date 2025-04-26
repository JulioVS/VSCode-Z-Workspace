#Import zoau utilitiy modules
from zoautil_py import mvscmd, datasets, jobs
import os

#set user ID as the High Level Qualifier. ENTER YOUR OWN USERID HERE.
HLQ="Z45864"

# create a sequential dataset
datasets.create("%s.PYTHON.DATA" % HLQ, dataset_type="seq", record_length = 80, 
record_format="FB", primary_space="100k")

# write your data in the dataset
datasets.write("%s.PYTHON.DATA" % HLQ, content='THIS IS JUST CONTENT CREATED BY USING PYTHON')

# check if the data is in the dataset
print(datasets.read("%s.PYTHON.DATA" % HLQ))

# get your username from the system and store it in user
user=os.environ.get("USER")

#print user
print('this program is executed by ' + user)
