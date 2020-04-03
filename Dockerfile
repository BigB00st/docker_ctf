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

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN sysctl -w kernel.dmesg_restrict=1

ARG user
ENV user=${user}

RUN useradd -ms /bin/bash "${user}" && \
echo "${user}:guest" | chpasswd && \
useradd -ms /bin/bash "${user}_pwn" && \
echo "${user}_pwn:password" | chpasswd && \
echo 'root:password' | chpasswd

WORKDIR "/home/${user}"

ARG binary
ADD $binary .

COPY ctf/flag .

RUN binary=$(basename $binary) && \
chown -R root:root "/home/${user}" && \
chown "${user}_pwn:${user}" "${binary}" && \
chmod 4550 "${binary}" && \
chown "${user}_pwn:root" flag && \
chmod 440 flag

# Open port 22
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
