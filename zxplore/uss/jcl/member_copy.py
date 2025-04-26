#! /usr/bin/env python3

# z/OS Automation Utilities Imports
#   Note: "zoautil_py.types" now upgraded to "ztypes"!
from zoautil_py import mvscmd
from zoautil_py.ztypes import DDStatement, FileDefinition, DatasetDefinition
from mvs_command_support import create_input_dd, cleanup_temporaries
import os


def check_errors(input_file_name: str, source: str, destination: str) -> str:
    message = ""
    badmembers = []
    found_bad_members = False

    with open(input_file_name, "r", encoding="cp1047") as input_file:
        for line in input_file.readlines():

            if "IGW01513T" in line:
                message = "Record Formats incompatible:"
                line_list = line.split()
                message = f"{message} {source} record format is {line_list[7]} "
                message = f"{message} {destination} record format is {line_list[11]}"

            elif "IEB127I" in line:
                message = "Record Formats incompatible:"
                line_list = line.split()
                input_recfm = line_list[5][6:]
                output_recfm = line_list[7][6:]
                message = f"{message} {source} record format is {input_recfm}"
                message = f"{message} {destination} record format is {output_recfm}"

            elif "IEB177I" in line:
                found_bad_members = True
                text_list = line.split()
                badmembers.append(text_list[1])

            elif "IEB124I" in line:
                message = "Record length incompatible:"
                line_list = line.split()
                input_lrecl = line_list[5].strip("()")
                output_lrecl = line_list[9].strip("().")
                message = f"{message} {source} record length is {input_lrecl}"
                message = f"{message} {destination} record length is {output_lrecl}"

            elif "913-00000038" in line:
                message = f"You are not authorized to {source}"

    if found_bad_members:
        if len(badmembers) > 1:
            message = f"Members: {', '.join(map(str,badmembers))} are not in dataset {source}."
        else:
            message = f"Member: {badmembers[0]} is not in dataset {source}."

    if len(message) < 1:
        message = f"z/OS Unchecked error please check out: {input_file_name}"

    return message


def member_copy(input_data_set: str, output_data_set: str, member_list: list) -> int:
    # Data Definition (DDs) list
    dd_list = []

    # Build input and output DSN DDs for the IEBCOPY command
    dd_list.append(DDStatement("INDS", DatasetDefinition(input_data_set.upper())))
    dd_list.append(DDStatement("OUTDS", DatasetDefinition(output_data_set.upper())))

    # Build output file for execution info
    output_file_path = "/z/z45864"
    output_file_name = f"{output_file_path}/copy_output"
    dd_list.append(DDStatement("SYSPRINT", FileDefinition(output_file_name)))

    # Build input comnnand instructions
    members = ','.join(map(str, member_list))

    dd_list.append(
        create_input_dd(
            [" COPY OUTDD=OUTDS,INDD=INDS", f" SELECT MEMBER=({members.upper()})"], 
            ddname="SYSIN"
        )
    )

    # Run IEBCOPY comannd (it returns an object)
    return_data = mvscmd.execute("IEBCOPY", dds=dd_list)

    # Convert result to Python Dictionary
    return_dictionary = return_data.to_dict()

    # Check Return Code
    if return_dictionary["rc"] == 0:
        print("Members copied!")
        os.remove(output_file_name)
    else:
        if return_dictionary["rc"] == 8:
            if "INDS" in return_dictionary["stderr_response"]:
                print(f"Error connecting to {input_data_set} - It probably doesn't exist")
            else:
                print(f"Error connecting to {output_data_set} - It probably doesn't exist")
        else:
            error_message = check_errors(output_file_name, input_data_set, output_data_set)
            if "Unchecked" in error_message:
                print(f"Error {return_dictionary['rc']} when trying to copy.")
                print(f"Error message is: {return_dictionary['stderr_response']}")
                print(f"Additional info can be found in {output_file_name}")
            else:
                print(error_message)

    # Some cleanup
    cleanup_temporaries()

    return return_dictionary['rc']


def main():
    return_code = member_copy(
                    'ZXP.PUBLIC.J2PDATA',
                    'Z45864.OUTPUT',
                    ['member1', 'member3', 'member6']
                    )

    if return_code == 0:
        print("Program ended")
    else:
        print("Program Abended")


if __name__ == "__main__":
    main()
