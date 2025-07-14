from zoautil_py import datasets

# create a variable for the High Level Qualifier using your Zuserid
HLQ = "Z45864"

# create a sequential dataset (type=seq)
datasets.create("%s.HACKDAYS.DATA" %HLQ, dataset_type="seq", record_length=80, record_format="FB", primary_space="10k")

# write your data in the dataset
datasets.write("%s.HACKDAYS.DATA" %HLQ, content='SENDHD22 dev=2732&user=Z45864&status=COMPLETE')

# optional: to check if the data is in the dataset
print(datasets.read("%s.HACKDAYS.DATA" %HLQ))
