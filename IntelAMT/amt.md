# AMT Serial-Over-LAN (SOL) on an HP 8540p/2540p  (from James Newsome)

This summarizes my experience getting AMT serial-over-lan to work on an HP 8540p. Serial-over-lan is a big help for debugging on machines without a physical serial port, such as the 8540p. These instruction likely apply to other hardware, as well.

You may also find this guide to be useful: [http://linux.die.net/man/7/amt-howto AMT Howto]

**DISCLAIMERS**

* ''A lost AMT password cannot be reset''. AMT is implemented in the firmware and chipset of the machine, and is designed to allow an IT department to control a company's machines, ''overriding the physically present user''. By design, physical presence is insufficient to reset the password if you lose it. When relinquishing ownership of a machine, make sure to tell the new owner the AMT password, or better-yet revert to the default password <tt>admin</tt> and disable AMT in the BIOS.

* ''A compromised AMT password is bad news''. AMT gives the power to update firmware, boot from a chosen device ''or network location'', power cycle, and more. Choose a good password and be careful that it's not compromised.

* ''Using the directions below on an open network will compromise your AMT password.'' We are using plaintext password authentication. An eavesdropper can easily grab it. I believe it's possible to enable encryption and stronger authentication; we should look into it.

## Enable AMT in firmware

You may need to enable AMT in the firmware. On the 8540p, you need to go to turn on system_config.amt_options.firmware_verbosity and setup_prompt.

## Configure AMT

Once AMT is enabled, you should see an AMT prompt during boot. Hit Ctrl-p to enter AMT configuration. The default password is 'admin'. Once you've logged in:

* ''You'll be forced to change the admin password''. Again, do not lose or compromise this password! The system will enforce some password rules. See this [http://linux.die.net/man/7/amt-howto AMT Howto].

* ''Setup the network.'' It's best not to make AMT accessible from the open network, if possible. In my case, I'm using a direct ethernet connection between my two machines, so I statically configured the host machine to 192.168.0.2.

* ''Activate the network''

* ''Make sure serial-over-lan (SOL) is enabled''

* ''Enable 'legacy redirection mode' (or SMB (Small Business) management mode)'' This enables a simpler network protocol. You'll need it to use amtterm. Unfortunately this also means we're doing password authentication and sending the password in the clear.

## Point your code at the AMT serial port

You can use <tt>dmesg | grep ttyS</tt> to examine the serial ports that your system now recognizes. On the 8540p the AMT serial port is recognized as ttyS0, but is at address <tt>0x6080</tt> instead of the usual <tt>0x3f8</tt>. For sechyp, you'll need to change the <tt>PORT</tt> macro in <tt>debug/uart.c</tt> to reflect this.

## Getting amtterm

Your best bet is to use amtterm 1.3 or higher. It is available from the author's [http://www.kraxel.org/cgit/amtterm/ git repository] or [http://www.kraxel.org/releases/amtterm/ releases directory].

## Patches

Most of the patches previously posted here are included in amtterm as of version 1.3. The no-truncate patch ([[Media:amtterm-no-truncate.patch.txt]]) hasn't been incorporated, but the corresponding bug should only effect you if using a user name or password greater than 63 bytes long.

## Connect from the client

In my case, since I'm using a direct ethernet connection, I need to bring up the ethernet interface: <tt>sudo ifconfig eth0 192.168.0.1</tt>. You'll need to repeat this whenever the link goes down, such as if the cable is unplugged, or either NIC resets (as on reboot).

I use: ./amtterm -p 'YourAMTpassword' 192.168.0.2

'''CAUTION''': your AMT password gets sent in plaintext over the network. Do not do this on an open network.
