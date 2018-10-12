FROM linuxconfig/apache
MAINTAINER Lubos Rendek <web@linuxconfig.org>

ENV DEBIAN_FRONTEND noninteractive

# Main package installation
RUN apt-get update
RUN apt-get -y install supervisor php-curl php-dom php-gd php-xml php-zip libapache2-mod-php wget unzip php-mbstring

# Download and extract Grav CMS
RUN wget -O grav.zip https://getgrav.org/download/core/grav/1.5.3
RUN unzip grav.zip -d /var/www/html/
# Install Grav Admin module
RUN cd /var/www/html/grav; bin/gpm install admin
RUN chown -R www-data.www-data /var/www/html/grav

# Configure Apache
RUN a2dissite 000-default
ADD grav.conf /etc/apache2/sites-available/
RUN a2ensite grav
RUN a2enmod rewrite

# Include supervisor configuration
ADD supervisor-apache.conf /etc/supervisor/conf.d/
ADD supervisord.conf /etc/supervisor/

# Clean up
RUN rm grav.zip
RUN apt clean

# Allow ports
EXPOSE 80 

# Start supervisor
CMD ["supervisord"]
