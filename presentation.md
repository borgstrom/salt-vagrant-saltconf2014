# Developing & Deploying with Salt and Vagrant

**SaltConf 2014**<br />
Presented by: Evan Borgstrom (<a href="http://github.com/borgstrom">@borgstrom</a>)

!

# Vagrant 101

&#8220;Development environments made easy.&#8221;

Vagrant provides a work flow to orchestrate the creation of virtual machines.

You provide a configuration in your <code>Vagrantfile</code> and Vagrant will create a VM from a template disk image and provision it to meet your specific needs.

!

# Vagrant is the *best* way to build software

* Solves the "works for me" problem
* Easily share settings with a team via SCM (Git, right?)
* Great tools & eco-system (Packer, provisioners, etc)

!

# Developers are <sub><sup>(usually)</sup></sub> not sys-admins

Vagrant gets a machine up, but you still need to get your code running on that machine.

Developers end up experimenting with what they find online, once again we end up with the problem of a setup that is hard to replicate on other team members machine.

!

# Enter Provisioners

Provisioners are what allow you to apply your configuration to your virtual machines.

Vagrant has a [Salt Provisioner][] built in!

It also has support for some of those other configuration engines, like Puppet, Chef, Ansible & Docker. It can even run shell snippets.

[Salt Provisioner]: http://docs.vagrantup.com/v2/provisioning/salt.html

!

# We have a problem

Provisioners are great but Salt introduces a huge learning curve when developers are first trying to use it with Vagrant.

Vagrant runs Salt in master-less mode by default, meaning the majority of the Salt documentation is confusing in the context of the Vagrant provisioned box.

!

# Got devops?

Developers that are working in teams and do not have the support of a full time devops team or person end up missing out on all of, or at least some of, the awesomeness.

!

# A little context

As a systems engineer who has used Salt extensively since 2010, the choice of using Salt as a way to provision development environments seems natural to me. However, I often need to remind myself that developers may not be as savvy as I am.

!

# The world of Marketing

The majority of work I do as a systems engineer involves working with interactive/digital teams tasked with building web apps, Facebook tabs, microsites, etc.

These teams are typically under very short deadlines and the software they build can have a very short life span. (ie. The promotion is live for 6 weeks and then is shutdown).

!

# Little room for process improvements

This environment of short deadlines and short lifespans leads to a situation where these teams **want** to improve their development process and work flow but rarely have the luxury to do so.

!

# Approaching the problem




!

# ...

Talk about how we approached the problem first (remote master). Problems encountered, lessons learned.

Talk about our simplification process and reverting to running with a local master.

Talk about leveraging formulas and why they are important for developers.

Introduce StackStrap
