// Copyright 2012 Citrix Systems, Inc. Licensed under the
// Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.  Citrix Systems, Inc.
// reserves all rights not expressly granted by the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
// Automatically generated by addcopyright.py at 04/03/2012
package com.cloud.network.vpc;

import com.cloud.acl.ControlledEntity;
import com.cloud.api.Identity;

public interface VpcGateway extends Identity, ControlledEntity {
    public enum Type {
        Private,
        Public,
        Vpn
    }
    
    public enum State {
        Creating,
        Ready,
        Deleting
    }
    
    long getId();

    /**
     * @return
     */
    String getIp4Address();

    /**
     * @return
     */
    Type getType();

    /**
     * @return
     */
    Long getVpcId();

    /**
     * @return
     */
    long getZoneId();

    /**
     * @return
     */
    Long getNetworkId();

    /**
     * @return
     */
    String getGateway();

    /**
     * @return
     */
    String getNetmask();

    /**
     * @return
     */
    String getVlanTag();

    /**
     * @return
     */
    State getState();
}
