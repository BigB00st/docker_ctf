# Select base image
FROM ubuntu:19.10

# Update the system, download any packages essential for the project
RUN dpkg --add-architecture i386 && \
apt-get update && \
apt-get install -y \
git \
build-essential \
make \
gcc \
python \
python-pip \
vim \
gdb \
radare2 \
openssh-server \
libc6:i386 \
libstdc++6:i386 \
libseccomp2:i386 

# SSH config
RUN mkdir /root/.ssh && \
mkdir /var/run/sshd

RUN echo 'root:password' | chpasswd && \
useradd -ms /bin/bash guest && \
echo 'guest:guest' | chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

WORKDIR /home/guest

# Variable to be specified at build time
ARG binary

ADD $binary .

COPY flag .

RUN chown root:root $binary && \
chmod 4755 $binary && \
chown root:root flag && \
chmod 600 flag

# Open port 22
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
