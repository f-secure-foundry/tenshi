tenshi
======

tenshi 0.17 README
Copyright 2004-2017 Andrea Barisani <andrea@inversepath.com>

Introduction
============

tenshi is a log monitoring program, designed to watch one or more log files for
lines matching user defined regular expressions and report on the matches. The
regular expressions are assigned to queues which have an alert interval and a
list of mail recipients.

Please read the example `tenshi.conf` and `tenshi.8` man page for usage
instructions.

tenshi was formerly known as wasabi. The name was changed to tenshi after we
were informed that wasabi is a registered trademark relating to another piece
of software.

It should be noted that tenshi was initially a perl rewrite of Oak
(http://www.ktools.org).

Installation
============

To install tenshi, add a user and group named `tenshi`. As root:

```
$ make install
```

Please read the manual before running tenshi to make sure you understand its
operation and that you satisfy the REQUIREMENTS section. Then edit the
configuration file `/etc/tenshi/tenshi.conf` according to your preferences.

Examples init scripts for OpenRC (Gentoo) and Debian are provided.

Examples
========

Consider the following settings in `tenshi.conf`:

```
set hidepid on

set queue mail     tenshi@localhost sysadmin@localhost [0 */12 * * *]
set queue misc     tenshi@localhost sysadmin@localhost [0 */24 * * *]
set queue critical tenshi@localhost sysadmin@localhost [now]

group ^ipop3d:

mail ^ipop3d: Login user=(.+)
mail ^ipop3d: Logout user=(.+)
mail ^ipop3d: pop3s SSL service init from (.+)
mail ^ipop3d: pop3 service init from (.+)
mail ^ipop3d: Command stream end of file, while reading.+
mail ^ipop3d: Command stream end of file while reading.+

critical ^ipop3d: Login failed.+

trash ^ipop3d:.+

group_end

critical ^sudo: (.+) : TTY=(.+) ; PWD=(.+) ; USER=root ; COMMAND=(.+)

misc .*
```

Every ipop3d message not matched by the regexps assigned to the queue mail or
critical will be matched by the queue trash (a builtin null queue), any other
message will be matched by queue misc. Fields enclosed in (.+) are masked.

This is a sample report for the mail queue (sent every 12 hours):

```
host1:
    79: ipop3d: Login user=___
    74: ipop3d: Logout user=___

host2:
    30: ipop3d: Login user=___
    30: ipop3d: Logout user=___
    19: ipop3d: pop3 service init from ___
    12: ipop3d: pop3s SSL service init from ___
    1: ipop3d: Command stream end of file while reading line user=??? host=bogus.domain.net [192.168.0.1]
    1: ipop3d: Command stream end of file, while reading authentication host=bogus1.domain.net [10.1.7.1]
```

These are sample reports for the critical queue (sent every time a message
matches the regexp):

```
host1:
    1: /usr/bin/sudo: ___ : TTY=___ ; PWD=___ ; USER=root ; COMMAND=/bin/dmesg

host1:
    1: /usr/bin/sudo: ___ : TTY=___ ; PWD=___ ; USER=root ; COMMAND=/bin/bash

host2:
    1: ipop3d: Login failed user=admin auth=admin host=bogus1.domain.net [10.1.7.1]

host2:
    1: ipop3d: Autologout user=??? host=bogus.domain.net [192.168.0.1]
```

Requirements
============

 * Perl.

 * A working `tail` implementation, when using the logfile option.

 * The Net::SMTP perl module to mail reports, typically included in perl
   installations.

 * The IO::BufferedSelect perl module.

 * The Redis perl module, when using the redisqueue option.

Any missing module can be downloaded from CPAN (http://www.cpan.org) or
installed using the CPAN shell (`perl -e shell -MCPAN`).

Resources
=========

The tenshi repository is hosted at https://github.com/inversepath/tenshi

Please report any bugs you find at <andrea@inversepath.com>.
