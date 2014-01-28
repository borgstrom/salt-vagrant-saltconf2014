# Developing & Deploying with Salt and Vagrant

**SaltConf 2014**<br />
Presented by: Evan Borgstrom ([@borgstrom][])

!

## Vagrant 101

&#8220;Development environments made easy.&#8221;

Vagrant provides a work flow to orchestrate the creation of virtual machines.

You provide a configuration in your <code>Vagrantfile</code> and Vagrant will create a VM from a template disk image and provision it to meet your specific needs.

!

## Vagrant is the *best* way to build software

* Solves the "works for me" problem
* Easily share settings with a team via SCM (Git, right?)
* Great tools & eco-system (Packer, provisioners, etc)
* Shared folders allows for developers to continue to use local IDEs & tools

!

## Developers are <sub><sup>(usually)</sup></sub> not system engineers

Vagrant gets a machine up, but you still need to get your code running on that machine.

Developers end up experimenting with what they find online, once again we end up with the problem of a setup that is hard to replicate on other team member machines.

!

## Enter Provisioners

Provisioners are what allow you to apply a configuration to your virtual machines.

Vagrant has a [Salt Provisioner][] built in!

It also has support for some of those other configuration engines, like Puppet, Chef, Ansible & Docker. It can even run simple shell commands.

!

## We have a problem...

Provisioners are great but Salt introduces a huge learning curve when developers are first trying to use it with Vagrant.

Vagrant runs Salt in master-less mode by default, meaning the majority of the Salt documentation is confusing in the context of the Vagrant provisioned box.

!

## Got devops?

Developers that are working in teams and do not have the support of a full time devops team or person end up missing out on all of, or at least some of, the awesomeness.

!

# Some context

!

## My background

I am a professional systems engineer with 13 years of experience who has used Salt extensively since 2010. This made the choice of using Salt as a way to provision development environments a "no-brainer" to me.

!

## The world of Marketing

The majority of work I do as a systems engineer involves working with interactive/digital teams tasked with building web apps, Facebook tabs, micro sites, etc.

These teams are typically under very short deadlines and the software they build can have a very short life span. (ie. The promotion is live for 6 weeks and then is shutdown).

!

## Little room for process improvements

This environment of short deadlines and short lifespans leads to a situation where these teams **want** to improve their development process and work flow but rarely have the luxury to do so.

!

## Approaching the problem

In 2013 I began working with [@brentsmyth][], who was at the time leading the development efforts at one of the agencies I work with.

He and I surmised that combining his deep understanding of the challenges faced in agency teams and my deep understanding of Salt and system engineering would allow us to dissect the problem and come up with a "elegant" solution.

!

## Starting line

The approach of distributing the states with your project works fine at first, but as soon as you start a second project the copy & paste begins and you end up loosing the reusability that makes Salt so great for configuration management.

This approach also deters the user from building reusable states as everything is tied to a specific project, making updates across all your projects is a PITA.

!

## Searching for a better way...

We looked at an existing project that had been built with Salt in master-less mode and began to dissect the process keeping track of the areas to improve.

!

# Remote Master

!

## Just another day for Salt

We first attempted to approach the problem using a "typical" Salt setup;  A remote master that the minions talked to following all of the recommended approaches for running Salt.

!

## Initial win!

This setup was an big improvement over the master-less mode.

It provided reusability in the state tree meaning the states for the development environment became simplified. It also meant that only Salt configs needed to be kept in the project repository itself.

But...

!

## Managing keys adds more complexity

With the master now in control of the minions it means that the operator of the master needs to come up with a strategy for managing keys.

!

## Accepting keys on the fly

You can go with a more traditional strategy of having each Vagrant box generate a key upon boot up and then manually accepting them as each box comes up.

Now whomever is responsible for the master has to manually accept the key when each box comes up. This adds a burden to the operations and means developers cannot spin up instances as they need them.

!

## Pre-accepting keys

You can go with a strategy of pre-accepting keys by generating them and placing them on the master in the correct directory.

Now you have a security asset to manage that is going to be shared by multiple users. This is poor security practice, especially if your salt server configures proprietary software/information/etc for production.

!

## Another server to run and manage

Another drawback of the remote master approach is that it requires a Salt master be up and running. If you have a devops team this may not be a huge burden, but for the development teams we work with they do not have such a team to support them.

!

## Hard to update project states

The final issue we ran into with the master mode, which partly ties into the previous point, is that typically the process for creating and getting the salt states onto the master requires manual work from one or more people (manual update, GIT push permissions, etc).

!

# Revisiting master-less mode

!

## Back to the drawing board

Now we know that a remote master only works in scenarios where the development team has proper operational support, we returned to the drawing board and re-examined how things worked in master-less mode and how we could gain the efficiencies a remote master offers without actually having to manage one.

!

## Reusing states

The biggest goal for this iteration was to remove the requirement to include the main state logic in the project repository while not requiring an external master.

!

## Utilizing the file server

Since Salt has a flexible file server that can serve up files from multiple roots we looked at how we can utilize this to gain our reusability.

!

## Setting up the minion

<table width="100%" border=0 cellspacing=20>
  <tr>
    <td valign=top>
<pre>state_verbose: False
file_client: local
file_roots:
  base:
    - /vagrant/salt/root
    - /srv/salt
pillar_roots:
  base:
    - /vagrant/salt/pillar
    - /srv/pillar</pre>
    </td>
    <td>The first entry in our minion config for file & pillar roots is our project specific states & pillars and the second entry is our global states and pillars.</td>
  </tr>
</table>

!

## Setting up Vagrant (part 1)

    $salt_repo_script = <<SCRIPT
    # install git
    salt-call pkg.install git
    
    # setup our /srv directory
    cd /tmp
    git clone https://github.com/freesurface/stackstrap-salt.git
    cd stackstrap-salt
    git archive master --prefix=/srv/ | (cd /; tar xf -)
    SCRIPT

!

## Setting up Vagrant (part 2)

    Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      ...

      # provision our box with salt but do not run the highstate yet
      config.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion"
        salt.run_highstate = false
      end
    
      # get our salt repository setup
      config.vm.provision :shell, inline: $salt_repo_script
    
      # now run the highstate
      config.vm.provision :shell, inline: "salt-call state.highstate"
    end

!

## Dissecting the Vagrant config

The first thing we do is define a little snippet that will clone a GIT repository containing state & pillar data, setting it up as <code>/srv</code>.

Then we tell the salt plugin not to run <code>highstate</code> initially. Instead we call our snippet then once it has completed we manually call <code>highstate<code>.

!

## Flexibility

The best thing about this setup is that it means you can define state & pillar data that is specific to your project while still taking advantage of a remote repository that contains all of the higher logic.

This allows developers to keep project specific state & pillar data in their repository while leveraging a separate repository of state & pillar that does all of the "heavy lifting".

!

# Formulas

!

## Integrating [Salt Formulas][]

Salt 0.17 officially introduced the concept of [Salt Formulas][]. They are fully encapsulated Salt states that each live in their own repository, under the [SaltStack Formulas GitHub Organization][].

!

## GitFS

To make these formulas super reusable Salt introduced a new file server backed named <code>GitFS</code>. This allows for a master to automatically pull in the repository and serve it up to clients.

!

## Local file client doesn't support GitFS

<code>:'(</code>

When you run in master-less mode Salt uses a Local file client that provides an interface analogous to the remote client, but unfortunately it does not implement the GitFS interface.

!

## Revisiting master mode

This time with a twist, the master now runs directly on the Vagrant VM, bound to the loopback, running in open mode.

This provides us with the facilities to utilize the [Salt Formulas][] without burdening operations folks with having to run a separate master.

!

## Configuring the minion

<table width="100%" border=0 cellspacing=20>
  <tr>
    <td valign=top>
<pre>master: 127.0.0.1
state_verbose: False<pre>
    </td>
    <td>Our minion config now becomes vastly simplified. We simply point at our loopback address for the master.</td>
  </tr>
</table>

!

## Configuring the master (part 1)

    # listen on the loopback in open mode
    interface: 127.0.0.1
    open_mode: True
    
    # use both the local roots as well as gitfs remotes
    fileserver_backend:
      - roots
      - git

!

## Configuring the master (part 2)

    # map our project specific files to the local roots
    file_roots:
      base:
        - /vagrant/salt/root
    pillar_roots:
      base:
        - /vagrant/salt/pillar
    
    # setup our salt formulas as gitfs remotes
    gitfs_remotes:
      - https://github.com/saltstack-formulas/nginx-formula.git

!

## Master config review

We first tell our master to only listen on the loopback interface, and to operate in open mode. We then tell it to use both the local roots as well as the GitFS backends.

Next we point our state & pillar file roots to our project.

Finally we add any formulas we want to use. These become available to our project states.

!

# Introducing [StackStrap][]

!

## There is an app for that

While the techniques and processes described here work great in an ad-hoc setup, our end-game desire has always been to encapsulate everything in a simple and easy to use package.

We are calling it [StackStrap][]

!

## Salt + Templates = Awesome

Aside from just automating the salt integration the other major focus of StackStrap is to provide a way to create reusable project templates.

This means that if a team is building a lot of apps that follow patterns they can create a template, with their salt logic built-in, and then quickly spin up projects based on the template.

!

## More info

You can find full documentation on RTFD: http://rtfd.org/stackstrap

Project info and development takes place on GitHub: https://github.com/freesurface/stackstrap

Feel free to reach out to myself ([@borgstrom][]) or [@brentsmyth][] if you have questions or want more info.

!

# EOF

Thanks!

[@borgstrom]: https://github.com/borgstrom
[@brentsmyth]: https://github.com/brentsmyth
[Salt Provisioner]: http://docs.vagrantup.com/v2/provisioning/salt.html
[StackStrap]: http://github.com/freesurface/stackstrap
[Salt Formulas]: TBD
[SaltStack Formulas GitHub Organization]: https://github.com/saltstack-formulas/
