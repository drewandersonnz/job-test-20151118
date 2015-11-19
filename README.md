# job-test-20151118

## Task:

    Using the following AWS credentials please provision a simple
    Node web application in a Docker container served by Nginx running
    on an EC2 instance provisioned by Ansible.

    The content served by the Node application can be anything.
    The container is to be hosted on a free Docker registry
    (ie. hub.docker.io or quay.io) and there are no restrictions on
    the number of git repositories that can be used.

    Please provide URLs, ELB or IP address where to access said
    application and URLs to all code.

## Process:

Configure config.local and set AWS credentials

    cp config.local.sample config.local && nano config.local
    source config.local

Setup local environment (install ansible)

    ./00-setup-local.bash

Using AWS credentials, provision a new VPC with internet gateway, new security group (22/tcp + 80/tcp), new keypair, launch Ubuntu instance, write new inventory hosts file

    ansible-playbook 01-provision-vpc-sg-keypair-launch_machine.yml

Copy hosts file to /et/ansible/hosts (please backup your existing)

    ./02-copy-host-to-ansible.bash

Install fail2ban on target for beginning SSH hardening (Ubuntu already has no accounts accessible via password, this is paranoia)

    ansible-playbook 10-harden-machines.yml

Install docker.io host on target

    ansible-playbook 11-setup-docker.yml

Push Node.js example express application to target, build container, start container (not publicly routable)

    ansible-playbook 12-docker-build-up-node.yml

Push NGINX example application to target, gather information about Node.js container, build NGINX container, start container

    ansible-playbook 13-docker-build-up-nginx.yml

At this point you can browse to http://target-ip/ found in your /etc/ansible/hosts file and
 * view a simple Node.js web application provisioned in a Docker container
 * served by NGINX in another Docker container
   * using internal Docker networking for communication between and simple service discovery to ensure IP isn't hard-coded
 * running on an Ubuntu EC2 instance
 * all provisioned by Ansible

## Tip:

You can get the address for target-ip from the "PLAY RECAP" at the end of the last playbook.

## Cleaning:

 * Log into AWS console
 * Terminate all instances within VPC
 * Delete VPC and all associated resources
 * Delete keypair (this will trip up any rebuilds as keypair cannot be saved twice)

## Questions and Enhancements?

 * Should I be deploying random images to the Docker Hub?
   * Avoided as I am only extending from the images provided
 * How do I maintain a Dynamic Inventory in Ansible?
   * Currently cheating with generating hosts file
 * Docker networking failures?
   * worked on 14.04, not on 15.10
 * Using variables on Playbooks (and on command line)
   * one playbook for targeting a single instance out of multiple
 * Calling Playbooks from a master Playbook
   * chaining changes
 * Service discovery for greater configuration of NGINX
   * Centralised across multiple hosts?
   * Or one (or more) NGINX per host accssing the internal containers using local configuration only?
   * How much cheating is not cheating? Using bash scripts to fake service discovery ...
 * NGINX configuration without rebuilding container
   * Live configuration injection? NGINX restart / reload?
   * If require rebuilding, could do "rolling restart" across multiple NGINX instances, Ansible can handle this for us
 * Attach AWS ELB to multiple NGINX instances
   * Do we need more than one NGINX per host machine?
 * How does Docker.io compare to LXC?
 * How does Docker.io / LXC access hardware resources (GPIO / I2C) for a Raspberry Pi deployment?
