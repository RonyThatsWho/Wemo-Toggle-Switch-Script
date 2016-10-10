# Wemo-Toggle-Switch-Script

Original script
http://moderntoil.com/?p=839&cpage=1

This is a script that was modified (from above) by myself to work as a simple toggle switch. It requires the user to know the 
current IP address of the device. It would first test known assigned ports to figure out which port the wemo is using. Once found
it will test the device's current state and depending on the state a command is sent to "flip the switch" in a sense


Usage: ./wemo IP_ADDRESS 
