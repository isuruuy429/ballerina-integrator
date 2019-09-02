#!/bin/bash
# ---------------------------------------------------------------------------
#  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

trap ctrl_c INT
set -e

function ctrl_c() {
    echo "cancelling build"
    exit 2;
}

pwd
#wget https://product-dist.ballerina.io/downloads/0.991.0/ballerina-linux-installer-x64-0.991.0.deb
wget https://product-dist.ballerina.io/dev/1.0.0-alpha3/ballerina-linux-installer-x64-1.0.0-alpha3.deb
sudo dpkg -i ballerina-linux-installer-x64-1.0.0-alpha3.deb
ballerina -v

wget https://www-eu.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
tar xzvf apache-maven-3.6.1-bin.tar.gz
cd apache-maven-3.6.1
pwd


cd /home/travis/build/isuruuy429/ballerina-integrator
mvn clean install

# cd /home/travis/build/isuruuy429/ballerina-integrator/examples/guides/services/healthcare-service
# ballerina init
# ballerina build --skiptests healthcare
# ballerina install --no-build healthcare

# ballerina build --skiptests util
# ballerina install --no-build util

# ballerina build --skiptests daos
# ballerina install --no-build daos

# cd /home/travis/build/isuruuy429/ballerina-integrator/examples/integration-tutorials
# ballerina init
# ballerina test