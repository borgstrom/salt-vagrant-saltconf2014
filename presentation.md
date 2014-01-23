# Developing & Deploying with Salt and Vagrant

**SaltConf 2014**<br />
Presented by: Evan Borgstrom (<a href="http://github.com/borgstrom">@borgstrom</a>)

!

# Vagrant 101

&#8220;Development environments made easy.&#8221;

Vagrant provides a work flow to orchestrate the creation of virtual machines.

You provide a configuration in your <code>Vagrantfile</code> and Vagrant will create a VM from a template disk image and provision it to meet your specific needs.

!

# Vagrant is the best way to build software

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

# Got devops?

Provisioners are great but Salt introduces a huge learning curve when developers are first trying to use it with Vagrant.

Vagrant runs Salt in master-less mode by default, meaning the majority of the Salt documentation is confusing in the context of the Vagrant provisioned box.

!

# 
