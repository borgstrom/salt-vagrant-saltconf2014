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

The majority of work I do as a systems engineer involves working with interactive/digital teams tasked with building web apps, Facebook tabs, micro sites, etc.

These teams are typically under very short deadlines and the software they build can have a very short life span. (ie. The promotion is live for 6 weeks and then is shutdown).

!

# Little room for process improvements

This environment of short deadlines and short lifespans leads to a situation where these teams **want** to improve their development process and work flow but rarely have the luxury to do so.

!

# Approaching the problem

In 2013 I began working with @brentsmyth, who was at the time leading the development efforts at one of the agencies I work with.

He and I surmised that combining his deep understanding of the challenges faced in agency teams and my deep understanding of Salt that together we could dissect the problem and come up with a solution.

!

# Salty Vagrant

At this point Vagrant did not have a Salt provisioner built in and you needed to install the [Salty Vagrant][] plugin to have Vagrant able to provision a VM using salt. Once the plugin was installed the suggested method for using Salt was to run the client in "local mode".

The method of running in "local mode" works fine at first. You include your top.sls file along with all of your states in your project repository and when Vagrant brings the machine

TODO: REVIEW THIS SLIDE

!

# Growing pains

The approach of distributing the states with your project works fine at first, but as soon as you start a second project the copy & paste begins and you end up loosing the reusability that makes Salt so great for configuration management.

This approach also deters the user from building reusable states as everything is tied to a specific project and making updates across all your projects is a PITA.

!

# Remote Master

!

# Another day in the life of Salt

We first attempted to approach the problem using a "typical" Salt setup;  A remote master that the minions talked to.

!

# Initial win!

This setup was an instant win. It provided reusability in the state tree meaning the states for the development environment became simplified. It also meant that nothing needed to be kept in the project repository itself.

!

# Managing keys adds more complexity

With the master now in control of the minions it means that the operator of the master needs to come up with a strategy for managing keys.

!

# Accepting keys on the fly

You can go with a more traditional strategy of having each Vagrant box generate a key upon boot up and then manually accepting them as each box comes up.

Now whomever is responsible for the master has to manually accept the key when each box comes up. This adds a burden to the operations and means developers cannot spin up instances as they need them.

!

# Pre-accepting keys

You can go with a strategy of pre-accepting keys by generating them and placing them on the master in the correct directory.

Now have a security asset to manage that is going to be shared by multiple users. This is poor security practice, especially if your salt server configures proprietary software/information/etc.

!

# Another server to run and manage

Another drawback of the remote master approach is that it requires a Salt master be up and running. If you have a devops team this may not be a huge burden, but for the development teams we work with they do not have such a team to support them.

!

# Hard to update project states

The final issue we ran into with the master mode, which partly ties into the previous point, is that typically the process for creating and getting the salt states onto the master requires manual work from one or more people (manual update, GIT push permissions, etc).

!

# Back to the drawing board

!

# Revisiting local mode

Now we know that a remote master only works in scenarios where the development team has proper operational support, we returned to the drawing board and re-examined how things worked in local mode and how we could gain the efficiencies of a remote master without actually having one.

!

# Reusing states

The biggest goal for this iteration was to remove the requirement to include the main state logic in the project repository while not requiring an external master.

!

# Utilizing the file server

Since Salt has a fairly flexible file server that can serve up files from multiple roots we looked at how we can utilize this to gain our reusability.

SALT CONFIG SCREEN SHOT

!

# Hiding complexities

VAGRANT FILE SCREEN SHOT

!

Talk about how we approached the problem first (remote master). Problems encountered, lessons learned.

Talk about our simplification process and reverting to running with a local master.

Talk about leveraging formulas and why they are important for developers.

Introduce StackStrap
