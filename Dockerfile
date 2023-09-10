FROM registry.fedoraproject.org/fedora-minimal:36
#FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:1.16-2

RUN microdnf install -y \
    iputils \
    kubernetes-client \
    bind-utils \ 
    java-11-openjdk-headless \ 
    nmap-ncat     \            
    python3 python3-pip python3-kafka \
    shadow \
    curl bind-utils netcat openssl tar gzip less jq vim-minimal \
&&  microdnf clean all


#RUN curl -L https://github.com/derailed/k9s/releases/download/v0.26.6/k9s_Linux_x86_64.tar.gz \
#    | tar xz --directory /usr/local/bin k9s

RUN echo "Welcome to the Axual Debug container!" > /etc/motd
RUN echo "cat /etc/motd" >> /etc/profile

# Copy custom configurations into the container.
COPY etc/* /etc/
# Copy all custom scripts into a directory on the $PATH.
COPY scripts/* /usr/local/bin/

COPY /kafka_scripts /usr/local/bin

RUN useradd -ms /bin/bash axual

USER axual

WORKDIR /home/axual/

COPY *.py /home/axual/

COPY etc/bashrc.local /home/axual/.bashrc

COPY       requirements.txt /home/axual/

RUN        pip install -r requirements.txt

#CMD ["/usr/local/bin/init.sh"]

CMD ["python", "cert_fetcher.py"]
