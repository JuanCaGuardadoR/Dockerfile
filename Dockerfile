#Imagen de BotsApp personalizada sin acceso ssh, no cambio de contraseña, no apt, no dpkg#


FROM debian:11

# Instalar paquetes necesarios para el contenedor
RUN apt-get update
RUN apt-get install -y \
	openssh-server \
	curl \
	sudo \
	wget \
	bash \
	git \
	supervisor \
	vim
# Carga la configuración de supervisor para iniciar servicios
RUN echo "[supervisord]" >>/etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >>/etc/supervisor/conf.d/supervisord.conf
RUN echo "" >>/etc/supervisor/conf.d/supervisord.conf
RUN echo "[program:sshd]" >>/etc/supervisor/conf.d/supervisord.conf
RUN echo "command=/usr/sbin/sshd -D" >>/etc/supervisor/conf.d/supervisord.conf


# Instala y configura ssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root123' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
CMD ["/usr/bin/supervisord"]
