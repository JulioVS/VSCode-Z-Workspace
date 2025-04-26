from zoautil_py import mvscmd, datasets, jobs
import os

# get your username from the system and store it in user
user = os.environ.get("USER")

# create a var that holds the DataSetName (dsn)
dsn = "%s.HACKDAYS.DATA" %user

# check if the dataset already exists, if not create one as with type SEQuential
# and some parameters to specify the size of it (both 1K will do for this task)
if not(datasets.exists(dsn)):
    datasets.create(dsn, dataset_type="SEQ", primary_space="1k", secondary_space="1k")

# create a variable command that holds the textline for the dataset
command = "SENDHD22 dev=2732&userid=Z45864&status=complete"

# next, write the data into your dataset, and just to be sure, overwrite any existing data
datasets.write(dsn, command, append=False)

# create a var to hold the name of the JCL JOB to run
dsnJCL = "ZXP.HACKDAYS.JCL(SENDDATA)"

# submit your JOB with job dataset in var dsnJCL
ZOAUresp = jobs._submit(dsnJCL, is_unix=False)
job=ZOAUresp.stdout_response

print(job)
print(user)

# END PART1
#   Record the JOBNAME from console ouput, copy it into PART2,
#   then run PART2.-
