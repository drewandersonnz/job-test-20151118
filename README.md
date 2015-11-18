# job-test-20151118

## Task:

    Using the following AWS credentials please provision a simple Node web application in a Docker container served by Nginx running on an EC2 instance provisioned by Ansible.

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
