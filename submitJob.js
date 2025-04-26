import { exec } from "child_process";
import config from "./config.json" with { type: 'json' };

const zowe_command = "zowe jobs submit ds '";   // submit job in Z
const zowe_flags = "' --wait-for-output --rfj"; // get output as JSON

exec(zowe_command + config.job + zowe_flags, (error, stdout, stderr) => {
  if (error) {
    console.error(`Error executing command: ${error.message}`);
    return;
  }
  if (stderr) {
    console.error(`Error: ${stderr}`);
    return;
  }
  console.log(`Output: ${stdout}\n`);

  // Parse the Mainframe Job Spool output
  var spool_data = JSON.parse(stdout).data;
  // Return Code will come in the form of "CC 0000"
  var return_code = spool_data.retcode.split(" ")[1];

  // Was the job successful?
  if (return_code <= config.maxRC) {
    console.log(`Job completed successfully! (${spool_data.retcode})`);
  } else {
    console.log(`Job failed with return code: ${return_code}`);
  }
});
