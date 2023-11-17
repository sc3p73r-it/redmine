Redmine

Redmine is a flexible project management web application written using Ruby on Rails framework.

More details can be found in the doc directory or on the official website http://www.redmine.org 
![image](https://github.com/sc3p73r-it/redmine/assets/140035139/b1fd481b-785a-479e-935c-89dc927d9cca)


OUR Project Site: https://pms.mdgportal.com/



<h1>Redmine Installation Step By Step Ubuntu 22.04</h1>

Install Required build tools and depenencies

<blockquote>
<p>
apt install build-essential \
	ruby-dev \
	libxslt1-dev \
	libmariadb-dev \
	libxml2-dev \
	zlib1g-dev \
	imagemagick \
	libmagickwand-dev \
	curl \
	gnupg2 \
	bison \
	libbison-dev \
	libgdbm-dev \
	libncurses-dev \
	libncurses5-dev \
	libreadline-dev \
	libssl-dev \
	libyaml-dev \
	libsqlite3-dev \
	sqlite3 -y
</p>
</blockquote>

<h3>Install Apache Web Server</h3>
<blockquote><p>apt install apache2 libapache2-mod-passenger</p></blockqoute><br>
<p>Apache Service start</p>
<blockquote><p>systemctl start apache2 && sytsemctl enable apache2</p></blockqoute>

<h3>Create Redmine System User</h3>
<blockquote><p>useradd -r -m -d /opt/redmine -s /usr/bin/bash redmine</p></blockqoute>

<p>Apache web server user add to redmine group.</p>
<code>usermod -aG redmine www-data</code>
