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

#include "../LoRaMac/RelayPacketForwarder.h"

#include "inet/networklayer/common/L3AddressResolver.h"
#include "inet/common/ModuleAccess.h"
#include "inet/applications/base/ApplicationPacket_m.h"
#include "LoRaPhy/LoRaRadioControlInfo_m.h"
#include "inet/physicallayer/wireless/common/contract/packetlevel/SignalTag_m.h"

using namespace flora;


Define_Module(RelayPacketForwarder);


void RelayPacketForwarder::initialize(int stage)
{
    if (stage == 0) {
        LoRa_GWPacketReceived = registerSignal("LoRa_GWPacketReceived");
        //localPort = par("localPort");
        //destPort = par("destPort");
    } else if (stage == INITSTAGE_APPLICATION_LAYER) {
        //startUDP();
        getSimulation()->getSystemModule()->subscribe("LoRa_AppPacketSent", this);
    }
}


void RelayPacketForwarder::handleMessage(cMessage *msg)
{
    EV << msg->getArrivalGate() << endl;
    if (msg->arrivedOn("socketIn")) {
        EV << "RELAY Received LoRaMAC frame" << endl;
        auto pkt = check_and_cast<Packet*>(msg);
        const auto &frame = pkt->peekAtFront<LoRaMacFrame>();
        if(frame->getReceiverAddress() == MacAddress::BROADCAST_ADDRESS)
            send(pkt, "socketOut");


    }
}



void RelayPacketForwarder::receiveSignal(cComponent *source, simsignal_t signalID, intval_t value, cObject *details)
{
    if (simTime() >= getSimulation()->getWarmupPeriod())
        counterOfSentPacketsFromNodes++;
}

void RelayPacketForwarder::finish()
{
    recordScalar("LoRa_GW_DER", double(counterOfReceivedPackets)/counterOfSentPacketsFromNodes);
}



//namespace inet
