FROM centos:7

RUN yum -y update && \
    yum -y install http://pkg.inclusivedesign.ca/centos/7/x86_64/Packages/idi-release-1.0-0.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-IDI && \
    yum -y install epel-release && \
    yum -y install ansible git sudo supervisor && \
    yum clean all

COPY supervisord.conf /etc/supervisord.conf

# Disable requiretty in /etc/sudoers, found at https://gist.github.com/petems/367f8119bbff011bf83e
# If we don't do this, Ansible is unable to use sudo within the localhost context
RUN echo "Removing requiretty" && \
    sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Configure Ansible to run locally by default
RUN echo '[local]' > /etc/ansible/hosts && \
    echo 'localhost' >> /etc/ansible/hosts && \
    echo '[defaults]' > /etc/ansible/ansible.cfg && \
    echo 'transport = local' >> /etc/ansible/ansible.cfg
