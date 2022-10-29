//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package floraext.Nodes;

import floraext.LoRaMac.RelayPacketForwarder;
import inet.node.contract.INetworkNode;
import inet.mobility.static.StationaryMobility;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.contract.INetworkLayer;
import inet.linklayer.loopback.LoopbackInterface;
import flora.LoRa.LoRaGWNic;
import flora.LoRaApp.SimpleLoRaApp;
import flora.LoRa.PacketForwarder;
import inet.linklayer.contract.IEthernetInterface;
import inet.applications.contract.IApp;


import inet.common.MessageDispatcher;

import inet.protocolelement.contract.IProtocolLayer;

module LoRaRelay like INetworkNode
{
    parameters:
        @networkNode();
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        *.energySourceModule = default(exists(energyStorage) ? absPath(".energyStorage") : "");

        int numWlanInterfaces = 1;

        int numUdpApps = default(1);

        LoRaGWNic.radio.antenna.mobilityModule = default("^.^.^.mobility");

        *.mobilityModule = default(exists(mobility) ? absPath(".mobility") : "");



        @display("bgb=783.96,587.688;i=abstract/accesspoint");
    gates:
        input radioIn[numWlanInterfaces] @directIn;

    submodules:
        interfaceTable: InterfaceTable {
            @display("p=135.36,69.936005");
        }
        mobility: StationaryMobility {
            @display("p=135.36,199.656");
        }
        LoRaGWNic: LoRaGWNic {
            @display("p=626.04004,94.75201");
        }
        relayPacketForwarder: RelayPacketForwarder {
            @display("p=392.424,85.104004");
        }
    connections allowunconnected:
        LoRaGWNic.upperLayerOut --> relayPacketForwarder.socketIn;
        relayPacketForwarder.socketOut --> LoRaGWNic.upperLayerIn;
}
