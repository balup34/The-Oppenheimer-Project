Installation:

STEP 1: Install robot framework and Python 3 
 
pip install robotframework

STEP 2: Install following libraries

pip install robotframework-requests

pip install robotframework-jsonlibrary





How to run Oppenheimer-Project Automation:


1.	To run all testcases use the below command:

robot --include 01_NPHC_Automation_Suite.robot

2.	To run only negative testcases use the below command:

robot --include negative 01_NPHC_Automation_Suite.robot

3.	To run only p0 (Blocker – Priority level 0) test cases use the below command:

robot --include p0 01_NPHC_Automation_Suite.robot

4.	To run only p1 (Critical – Priority level 1) test cases use the below command:

robot --include p1 01_NPHC_Automation_Suite.robot

5.	To run only p2 (Major – Priority level 2) test cases use the below command:

robot --include p2 01_NPHC_Automation_Suite.robot






Prerequisites:

1. Jar file should be present in local project directory For Robot Suite Setup run
2. File1.csv should be present in local project directory for running csv upload tests automation run





NOTES:
1.	Please refer Test Plan Document for E2E details on product and testing scope
2.	Tested this Automation run on macOS BigSur Version 11.6.2. Robot scripts should run across all platforms without any issues. Please let automation team know if you face any issues

