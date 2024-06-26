#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.






host=""
account=""
templateid=""
storage=""
var=""

while getopts h:s:a:i: OPTION
do
  case $OPTION in
  a)    account="$OPTARG"
        ;;
  i)    templateid="$OPTARG"
                ;;
  h)    host="$OPTARG"
                ;;
  s)    storage="$OPTARG"
  esac
done

var=`ssh root@$host "cd $storage &&  mv template/tmpl/$account/$templateid/template.properties template/tmpl/$account/$templateid/template.properties1 && touch template/tmpl/$account/$templateid/template.properties"`


if  [ "$var" != "" ]
then echo "Was unable to corrupt template $path on host $host"
exit 2
else
exit 0
fi
