*** Settings ***

Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    Process
Suite Setup     Launch Application


*** Variables ***

${base_url}=    http://localhost:8080/

*** Keywords ***

Launch Application
    Start Process    java    -jar    OppenheimerProjectDev.jar
    ${result}=    Wait For Process    timeout=1min 30s    on_timeout=kill
    Log    ${result.stdout}
    Get Process Id  handle=None

*** Test Cases ***

TESTCASE:1
     [Documentation]    Check WebApp is accessible or not
     [Tags]    sanity
     ${response}=    GET  ${base_url}  expected_status=200

TESTCASE:2
     [Documentation]    Validate webApp actuator accessibility
     [Tags]    sanity
     ${response_dispense}=    GET  ${base_url}/actuator  expected_status=200

TESTCASE:3
     [Documentation]    Validate Clerk able to insert a single record of working class hero into database via an API
     [Tags]    p0
     Create Session  mysession  ${base_url}/calculator/  verify=true
     &{data}=    Create dictionary  birthday=19081765  gender=m  name=test1  natid=1245  salary=1500  tax=54
     ${resp}=    POST On Session    mysession  /insert  json=${data}  expected_status=202
     Status Should Be  202  ${resp}
     &{data}=    Create dictionary  birthday=19081765  gender=f  name=test1  natid=1245  salary=1500  tax=54
     ${resp}=    POST On Session    mysession  /insert  json=${data}  expected_status=202
     Status Should Be  202  ${resp}

TESTCASE:4
     [Documentation]    Validate Clerk able to insert more than one working class hero into database via an API
     [Tags]    p1
     Create Session  mysession  ${base_url}/calculator/  verify=true
     &{data}=    Create dictionary  birthday=19081765  gender=f  name=rest  natid=12455  salary=1500  tax=54
     ${resp}=    POST On Session    mysession  /insertMultiple  json=${data}  expected_status=202
     Status Should Be  202  ${resp}
     log to console  ${response.status_code}

TESTCASE:5
     [Documentation]    Validate Bookkeeper, able to query the amount of tax relief for each person in the database
     [Tags]    p0
     ${response}=    GET  ${base_url}/calculator/taxRelief  expected_status=200

TESTCASE:6
     [Documentation]    4 a)GET endpoint which returns a list consist of natid, tax relief amount and name
     [Tags]    p0
     # Need to add more validation
     ${response}=    GET  ${base_url}/calculator/taxRelief  expected_status=200

TESTCASE:7
     [Documentation]    4 b) natid field must be masked from the 5th character onwards with dollar sign ‘$’
     [Tags]    p1
     ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=-$$$$$$$  expected_status=200

TESTCASE:8
     [Documentation]    4 d) After calculating the tax relief amount, it should be subjected to normal rounding rule to remove any decimal places
     [Tags]    p1
     ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=.00  expected_status=200
     log to console  ${response.status_code}

TESTCASE:9
     [Documentation]    4 e) If the calculated tax relief amount after subjecting to normal rounding rule is more than 0.00 but less than 50.00, the final tax relief amount should be 50.00
     [Tags]    p2
     ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=50.00  expected_status=200
     log to console  ${response.status_code}
     
TESTCASE:10
     [Documentation]    4 f) If the calculated tax relief amount before applying the normal rounding rule gives a value with more than 2 decimal places, it should be truncated at the second decimal place and then subjected to normal rounding rule
     [Tags]    p2
     ${response}=    GET  ${base_url}/calculator/taxRelief  params=query=.00  expected_status=200

TESTCASE:11
    [Documentation]    5. Validate Governor able to see a button on the screen to dispense tax relief
    [Tags]    p2
    ${response}=    GET  ${base_url}/dispense  expected_status=200

TESTCASE:12
    [Documentation]    5 b) The text on the button must be exactly “Dispense Now”
    [Tags]    p2
    ${response}=    GET  ${base_url}/dispense  params=query=Dispense!!  expected_status=200

TESTCASE:13
    [Documentation]    After clicking on the button, it should direct me to a page with a text that says “Cash dispensed”
    [Tags]    p2
    ${response}=    GET  ${base_url}/dispense  params=query=Cash dispensed  expected_status=200

TESTCASE:14
    [Documentation]  Validate that able to Remove all records from DB
    [Tags]    p2
    ${response}=    POST  ${base_url}/calculator/rakeDatabase  params=query=Successfully raked DB  expected_status=200

TESTCASE:15
    [Documentation]  Validate the BIRTHDAY format should be DDMMYYYY
    [Tags]    p0
    Create Session  mysession  ${base_url}/calculator/  verify=true
    &{data}=    Create dictionary  birthday=19JAN1765  gender=m  name=test1  natid=1245  salary=1500  tax=54
    ${resp}=    POST On Session    mysession  /insert  json=${data}  expected_status=500
    Status Should Be  500  ${resp}


#NEGATIVE TESTCASES:


TESTCASE:16
    [Documentation]  WebApp should not allow to invalid values for gender, it should be "m or f"
    [Tags]    p0  negative
    Create Session  mysession  ${base_url}/calculator/  verify=true
    &{data}=    Create dictionary  birthday=19081765  gender=male  name=test1  natid=1245  salary=1500  tax=54
    ${resp}=    POST On Session    mysession  /insert  json=${data}  expected_status=500
    Status Should Be  500  ${resp}
    &{data}=    Create dictionary  birthday=19081765  gender=female  name=test2  natid=12457  salary=1500  tax=54
    ${resp}=    POST On Session    mysession  /insert  json=${data}  expected_status=500
    Status Should Be  500  ${resp}


*** Comments ***

#WORK IN PROGRESS

TESTCASE:12
    [Documentation]    5 a) The button on the screen must be red-colored
    # NO API endpoint Available

Testcase : 5
     [Documentation]    Validate Clerk able to upload a csv file to a portal to populate the database from a UI
     [Tags]    NeedToFix
     Create Session  Alias  ${base_url}
     ${data}  Create Dictionary   inputFileTypeId=1  dataType=csv
     Set to Dictionary   ${data}
     ${file_data}  Get Binary File  ${CURDIR}${/}File1.csv
     ${files}  Create Dictionary  File1.csv  ${file_data}
     Log  ${files}
     Log  ${data}
     ${resp}  POST On Session  ALias  ${base_url}  files=${files}  data=${data}
     Log  ${resp}
     Should Be Equal As Strings  ${resp.status_code}  200


Testcase : 3a
     [Documentation]    3 a) Validate that First row of the csv file must be natid, name, gender, salary, birthday, tax
     [Tags]    record
Testcase : 3b
     [Documentation]    3 b) Validate that Subsequent rows of csv are the relevant details of each working class hero
     [Tags]    record
Testcase : 3c
     [Documentation]    3 c) Validate that A simple button that allows to upload a file from pc to the portal
     [Tags]    record
         # NO API endpoint Available
