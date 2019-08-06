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
import util;

type DoctorNotFoundError error<string>;

# Healthcare DAO record.
#
# + doctorsList - list of doctors in the Healthcare DAO 
# + categories - list of categories doctors are specialized 
# + payments - payments map of Healthcare DAO
public type HealthcareDao record {
    Doctor[] doctorsList = [];
    string[] categories = [];
    map<Payment> payments = {};
};

# Hospital payment record.
#
# + appointmentNo - appoinment number 
# + doctorName - doctor name
# + patient - patient name 
# + actualFee - payment fee 
# + discount - discount percentage for the payment 
# + discounted - discounted amount for the payment 
# + paymentID - payment id 
# + status - status of the payment
public type Payment record {
    int appointmentNo;
    string doctorName;
    string patient;
    float actualFee;
    int discount;
    float discounted;
    string paymentID;
    string status;
};

# Payment settlement record.
#
# + appointmentNumber - appointment number 
# + doctor - doctor 
# + patient - patient 
# + fee - payment settlement fee 
# + confirmed - confirmed 
# + cardNumber - card number using for the payment
public type PaymentSettlement record {
    int appointmentNumber;
    Doctor doctor;
    Patient patient;
    float fee;
    boolean confirmed;
    string cardNumber;
};

# Channeling fee record.
#
# + patientName - patient name 
# + doctorName - doctor name 
# + actualFee - channeling fee
public type ChannelingFee record {
    string patientName;
    string doctorName;
    string actualFee;
};

# Find doctors from the given category in the healthcare DAO.
#
# + healthcareDao - healthcareDAO record 
# + category - doctor category 
# + return - list of doctors
public function findDoctorByCategoryFromHealthcareDao(HealthcareDao healthcareDao, string category) 
            returns Doctor[] {
    Doctor[] list = [];
    foreach var doctor in healthcareDao.doctorsList {
        if (util:equalsIgnoreCase(category, doctor.category)){
        //if (category.equalsIgnoreCase(doctor.category)){
            list[list.length()] = doctor;     
        }
    }
    return list;
}

# Find doctor by given name in healthcare DAO.
#
# + healthcareDao - healthcareDAO record 
# + name - doctor name  
# + return - doctor matching to the given name | doctor not found error
public function findDoctorByNameFromHelathcareDao(HealthcareDao healthcareDao, string name) 
        returns Doctor|DoctorNotFoundError {
    foreach var doctor in healthcareDao.doctorsList {
        //if (name.equalsIgnoreCase(doctor.name)) {
        if (util:equalsIgnoreCase(name, doctor.name)) {
            return doctor;
        }

        if(util:equalsIgnoreCase(name, doctor.name)){
            return doctor;
        }
    }
    DoctorNotFoundError docNotFoundError = error("Doctor Not Found: " + name);
    return docNotFoundError;
}

//----from utils-----------------------------------------------

# Create new payment entry.
#
# + paymentSettlement - paymentSettlement record
# + healthcareDao - healthcareDAO record
# + return - Payment record created | error
public function createNewPaymentEntry(PaymentSettlement paymentSettlement, HealthcareDao healthcareDao) 
                                            returns Payment|error {
    int|error discount = util:checkForDiscounts(<string>paymentSettlement["patient"]["dob"]);
    if(discount is int) {
        string doctorName = <string>paymentSettlement["doctor"]["name"];
        Doctor|error doctor = findDoctorByNameFromHelathcareDao(healthcareDao, doctorName);
        if(doctor is Doctor){
            float discounted = (<float>doctor["fee"] / 100) * (100 - discount);

                Payment payment = {
                appointmentNo: <int>paymentSettlement["appointmentNumber"],
                doctorName: <string>paymentSettlement["doctor"]["name"],
                patient: <string>paymentSettlement["patient"]["name"],
                actualFee: <float>doctor["fee"],
                discount: discount: 0,
                discounted: discounted: 0.0,
                paymentID: system:uuid(),
                status: ""
            };
            return payment;
        } else {
            return doctor;
        }
    } else {
        return discount;
    }
}





