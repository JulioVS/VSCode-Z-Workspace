from zoautil_py import mvscmd, datasets, jobs

job = "JOB04583"    # Copy JOBID from PART1 run
user = "Z45864"

dds = jobs.list_dds(job, owner=user)

print(job)
print(user)
print(dds)

for item in dds:
    if item["dd_name"] == "SYSTSPRT":
        # when found, store the dataset into report
        report = jobs.read_output(job, item['step_name'], item['dd_name'], owner=user)

        # and print out the results
        print(report)

        lines = report.splitlines()
        print(lines)

        for line in lines:
            if line.find("OK") == 1:
                token = line.strip().split(" ")[1]

# print the token to the screen
print("token is %s" %token)
