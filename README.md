1x3 Network Router & SystemVerilog Verification Environment
Overview
This repository contains the RTL design of a synchronous 1x3 Network Router and a fully featured, layered SystemVerilog verification environment. The project demonstrates advanced ASIC verification techniques, including object-oriented programming (OOP), constrained randomization, SystemVerilog Assertions (SVA), and functional coverage.

RTL Design: 1x3 Router
The design under test (DUT) is a 1-input, 3-output synchronous packet router.

Protocol: The router expects a data stream where the first byte is the "Header" (containing the destination port in the lower 2 bits), followed by the payload.

State Machine: A 2-state FSM (Waiting for Header and Routing Payload) parses the incoming data enable (din_en) and routes the payload dynamically to dout0, dout1, or dout2.

Verification Environment Architecture
The testbench is built from scratch using a modern, layered SystemVerilog architecture.

Key Verification Features:
Constrained Randomization: The packet class generates dynamic payloads (10-20 bytes) and uses weighted distributions (dist) to stress-test specific routing paths (e.g., forcing 70% of traffic to Port 0 to test back-to-back routing).

SystemVerilog Assertions (SVA): The router_if interface includes concurrent assertions to continuously monitor for protocol violations, such as X (unknown) values appearing on the data bus while enabled, or data being driven during an active reset.

Concurrent Monitoring: The monitor class utilizes fork...join_none to spawn independent, concurrent threads that passively observe all three output ports simultaneously.

Functional Coverage: A subscriber class implements a covergroup to track test completeness. It defines coverpoints for destination addresses and payload sizes, along with cross coverage to ensure all payload lengths are successfully routed to all possible ports.

Automated Checking: A standalone scoreboard receives expected packets from the generator and actual reconstructed packets from the monitor, performing byte-by-byte payload and address comparisons.

Simulation Flow
The generator creates randomized packets and passes them to the driver via mailboxes.

The driver wiggles the virtual interface pins to drive the header and payload synchronously.

The monitor reconstructs the routed packets and sends them to the scoreboard and subscriber.

Real-time coverage metrics and Pass/Fail scoreboard results are printed to the simulation console.
