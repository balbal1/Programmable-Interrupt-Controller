# Programmable Interrupt Controller
This is the project of CSE311 Computer Architecture.
The project aims to design and implement a Programmable Interrupt Controller (PIC) based on the 8259-architecture using Verilog hardware description language. The 8259 PIC is a crucial component in computer systems responsible for managing and prioritizing interrupt requests, facilitating efficient communication between peripherals and the CPU.
## Contributors
|**Name**| **ID** | 
|--|--|
| Ali Mohsen Yehia Ateya | 2000289 |
| Amr Essam Mahmoud Anwar  | 2001089 |
| Ahmed Adel Abdelrahman | 2001778 |
| Nassar khaled masoud | 2001464 |
| Ahmed Sherif Mohamed | 2001547 |
| Adham mohamed mohamed | 2001378 |
## Key Features
* 8259 Compatibility:<br>
The Verilog implementation will closely emulate the behavior and features of the classic 8259 PIC, ensuring compatibility with existing systems and software.
* Programmability:<br>
The project will include support for programming interrupt priorities and modes, allowing users to configure, using Command Words (ICWs) and Operation Command Words (OCWs), the PIC according to their specific requirements.
* Cascade Mode:<br>
Implementing the cascade mode, where multiple PICs can be interconnected to expand the number of available interrupt lines, enhancing the scalability of the design.
* Interrupt Handling:<br>
Efficient handling of interrupt requests, including prioritization and acknowledgment mechanisms, to ensure a timely and accurate response to various events.
* Interrupt Masking:<br>
Implement the ability to mask/unmask individual interrupt lines to control which interrupts are currently enabled.
* Edge/Level Triggering:<br>
Support both edge-triggered and level-triggered interrupt modes to accommodate different types of peripherals.
* Fully Nested Mode:<br>
Implement Fully Nested Mode, allowing the PIC to automatically set the priority of the CPU to the highest priority interrupt level among the currently serviced interrupts.
* Automatic Rotation:<br>
Extend the priority handling mechanism to support automatic rotation even in scenarios where lower-priority interrupts are being serviced.
* EOI:<br>
Implement the EOI functionality, allowing the PIC to signal the end of interrupt processing to the CPU.
* AEOI:<br>
Implement the EOI functionality, allowing the PIC automatically to signal the end of interrupt processing to the CPU.
* Reading the 8259A Status:<br>
Implement the capability to read the status of the 8259A PIC.
## Modules:
![](https://i.imgur.com/1h4ifV7.png)<br>
*top level module*
* ControlLogic<br>
This module is responsible for receiving the ICWs and OCWs to store them, and sending the databus_output to DataBusBuffer and enabling it to write on the data bus.
* IRR<br>
This module is responsible for storing the raised interrupts from the devices through level detection or edge detection, and resetting them when they are handled.
* IMR<br>
This module is responsible for storing the masked interrupts.
* PriorityResolver<br>
This module is responsible for deciding the highest priority interrupt to send from IRR to ISR, handling rotation, and raising the INT signal to the CPU in case of interrupt
* PriorityLevel<br>
This module is responsible for outputing the highest priority bit and its level from IRR or from ISR based on the values in priority register.
* ISR<br>
This module is responsible for storing the currently serviced interrupts and resetting them after serving whether immediately in case of AEOI or after the command in case of normal EOI.
* DataBusBuffer<br>
This module is responsible for driving the data bus when sending the vector address or the CPU want to read a register, and reading the command words from the CPU.
* Cascade<br>
This module is responsible for deciding if the chip is master or slave, and driving the CAS lines in case of master, or reading the CAS lines in case of slave to decide if the chip will send vector address or not.
* ReadWriteLogic<br>
This module is responsible for reading the WR and RD signals from the CPU and enabling them with CS.