// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/http;
import ballerina/system;
import ballerina/time;
import ballerina/log;
import ballerina/lang.'int as ints;
import ballerinax/java;

// Initialize appoint number as 1.
int appointmentNo = 1;
// Conversion error.
type CannotConvertError error<string>;

# Send HTTP response.
#
# + caller - HTTP caller 
# + payload - payload or the response
# + statusCode - status code of the response
public function sendResponse(http:Caller caller, json|string payload, int statusCode = 200) {
    http:Response response = new;
    response.setPayload(<@untainted> payload);
    response.statusCode = statusCode;
    var result = caller->respond(response);
    if (result is error) {
        log:printError("Error sending response.", err = result);
    }
}

# Check whether given string contains in the given array.
#
# + arr - array 
# + element - string want to check
# + return - given string is contains in the array
public function containsStringElement(string[] arr, string element) returns boolean {
    foreach var item in arr {
        if (equalsIgnoreCase(item,element)) {
            return true;
        }
    }
    return false;
}



# Convert JSON array to string array.
#
# + array - JSON array want to convert 
# + return - converted string array
public function convertJsonToStringArray(json[] array) returns string[] {
    string[] result = [];
    foreach var item in array {
        result[result.length()] = <string>item;
    }
    return result;
}




# Discount is calculated by checking birth year of the patient.
#
# + dob - date of birth as a string in yyyy-MM-dd format 
# + return - discount value
public function checkForDiscounts(string dob) returns int|error {
   // int|error yob = int.convert(dob.split("-")[0]);
    handle dobStr = java:fromString(dob);
    handle delimeter = java:fromString("-");
    handle dateArray = split(dobStr, delimeter);
    handle yob = java:getArrayElement(dateArray, 0);
    string yobs = yob.toString();
    int|error yobInt = ints:fromString(yobs);
    
    if(yobInt is int) {
        int currentYear = time:getYear(time:currentTime());
        int age = currentYear - yobInt;
        if (age < 12) {
            return 15;
        } else if (age > 55) {
            return 20;
        } else {
            return 0;
        }
    } else {
        CannotConvertError err = error("Invalid Date of birth:" + dob);
        return err;
    }
}

# Check discount eligibility by checking the birth year of the patient.
#
# + dob - date of birth as a string in yyyy-MM-dd format 
# + return - eligibity for discounts | error
public function checkDiscountEligibility(string dob) returns boolean | error {
    handle dobStr = java:fromString(dob);
    handle delimeter = java:fromString("-");
    handle dateArray = split(dobStr, delimeter);
    handle yob = java:getArrayElement(dateArray, 0);
    string yobs = yob.toString();
    int|error yobInt = ints:fromString(yobs);
    //var yob = int.convert(dob.split("-")[0]);
    if (yobInt is int) {
        int currentYear = time:getYear(time:currentTime());
        int age = currentYear - yobInt;

        if (age < 12 || age > 55) {
            return true;
        } else {
            return false;
        }
    } else {
        log:printError("Error occurred when converting string dob year to int.", err = ());
        return yobInt;
    }
}


public function equalsIgnoreCase(string str1, string str2) returns boolean {
if (str1.toUpperAscii() == str2.toUpperAscii()) {
return true;
} else {
return false;
}
}

function split(handle receiver, handle delimeter) returns handle = @java:Method {
    //[name: "split"],
    class: "java.lang.String"
} external;


