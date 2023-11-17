Redmine

Redmine is a flexible project management web application written using Ruby on Rails framework.

More details can be found in the doc directory or on the official website http://www.redmine.org 
![image](https://github.com/sc3p73r-it/redmine/assets/140035139/b1fd481b-785a-479e-935c-89dc927d9cca)


OUR Project Site: https://pms.mdgportal.com/



<h1>Redmine Installation Step By Step Ubuntu 22.04</h1>

Install Required build tools and depenencies

<blockquote><p>
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
</p></blockquote>

<h3>Install Apache Web Server</h3>
<code>apt install apache2 libapache2-mod-passenger</code>

<code>systemctl start apache2 && sytsemctl enable apache2</code>

<h3>Create Redmine System User</h3>
<code>useradd -r -m -d /opt/redmine -s /usr/bin/bash redmine</code>

<p>Apache web server user add to redmine group.</p>
<code>usermod -aG redmine www-data</code>

<h3>Install MariaDB</h3>
<code>apt install mariadb-server</code><br>
<code>systemctl start mariadb && systemctl enable mariadb</code><br>
<code>mysql_secure_installation</code><br>

<h3>Create Redmine Database and Database User</h3>
<code>mysql -u root -p</code><br>
<code>create database redminedb;</code><br>
<code>grant all on redminedb.* to redmineuser@localhost identified by 'password';</code><br>
<code>flush privileges;</code><br>
<code>quit;</code><br>

<h3>Download and Install Redmine</h3>

<a href="https://www.redmine.org/projects/redmine/wiki/Download">Redmine Download Page</a>

<p>you can download and extract the redmine zip file.</p>
<code>curl -s https://www.redmine.org/releases/redmine-$VER.tar.gz | \ sudo -u redmine tar xz -C /opt/redmine/ --strip-components=1</code>

<h3>Configure Redmine</h3>
<p>Once you have installed Redmine under the /opt/redmine directory, you can now proceed to configure it.</p>

<h3>Create Redmine Configuration files</h3>
<code>su - redmine</code> <br>
<code> cp /opt/redmine/config/configuration.yml.example /opt/redmine/config/configuration.yml</code> <br>
<code> cp /opt/redmine/config/dispatch.fcgi.example /opt/redmine/config/dispatch.fcgi</code> <br>
<code> cp /opt/redmine/config/database.yml.example /opt/redmine/config/database.yml</code> <br>


<h3>Configure Database Setttings</h3>
<code>vim /opt/redmine/config/database.yml</code>
<quoteblock>
<p>production:
  adapter: mysql2
  database: redminedb
  host: localhost
  username: redmineuser
  password: "P@ssW0rD"
  # Use "utf8" instead of "utfmb4" for MySQL prior to 5.7.7
  encoding: utf8mb4
  </p>
</quoteblock>
<p>save and exit the file and logout redmine user</p>

<h3>Install the Redmine Ruby Dependencies</h3>
<code>cd /opt/redmine</code>

<p>Install Bundler for managing gem dependencies.</p>
<code>sudo gem install bundler</code>

<p>Next, install the required gems dependencies as redmine user.</p>
<code>su - redmine</code> <br>
<code>bundle config set --local path 'vendor/bundle'</code> <br>
<code>bundle install</code> <br>

<p>Also update the gems;</p>
<code>bundle update</code>

<p>Install updated io-wait and strscan gems;</p>
<code>gem install io-wait strscan webrick --user-install</code>

<h3>Generate Secret Session Token</h3>
<p>To prevent tempering of the cookies that stores session data, you need to generate a random secret key that Rails uses to encode them.</p>
<code>bundle exec rake generate_secret_token</code>


<h3>Create Database Schema Objects</h3>
<p>Create Rails database structure by running the command below.Ensure you set the correct database credentials above.</p>
<code>RAILS_ENV=production bundle exec rake db:migrate</code>
<p>Once the database migration is done, insert default configuration data into the database by executing;</p>
<code>RAILS_ENV=production REDMINE_LANG=en bundle exec rake redmine:load_default_data</code>

<p>You can safely ignore the Ruby warnings.</p>

<h3>Configure FileSystem Permissions</h3>
<p>Ensure that the following directories are available on Redmine directory, /opt/redmine.<p>

<ul>
<li>tmp and tmp/pdf</li>
<li>public and public/plugin_assets</li>
<li>log</li>
<li>files</li>
</ul>

<p>If they do not exist, simply create them and ensure that they are owned by the user used to run Redmine.</p>
<code>for i in tmp tmp/pdf public/plugin_assets; do [ -d $i ] || mkdir -p $i; done</code> <br>
<code>chown -R redmine:redmine files log tmp public/plugin_assets</code> <br>

```
chmod -R 755 /opt/redmine
```

<h3>Testing Redmine Installation</h3>
<p>You can now test Redmine using WEBrick by executing the command below</p>

``` 
su - redmine
```

<p>Add webrick to Gemfile</p>

```
echo 'gem "webrick"' >> Gemfile
```

<p>Install webrick gem and test the installation</p>

```
bundle install 
```
``` 
bundle exec rails server -u webrick -e production
```

<p>Sample Output</p>
<blockquote>
<p>
=> Booting WEBrick
=> Rails 6.1.7.6 application starting in production http://0.0.0.0:80
=> Run `bin/rails server --help` for more startup options
[2023-11-12 18:54:22] INFO  WEBrick 1.8.1
[2023-11-12 18:54:22] INFO  ruby 3.0.2 (2021-07-07) [x86_64-linux-gnu]
[2023-11-12 18:54:22] INFO  WEBrick::HTTPServer#start: pid=8940 port
</p>
</blockquote>

<p>Navigate to the browser and enter the address, http://server-IP. Replace the server-IP accordingly.</p>

<h3>Configure Apache For Redmine</h3>
<p>next, create Redmine Apache VirtualHost configuration file.</p>


# Redmine Apache Configuration

Below is a sample Apache configuration for hosting Redmine on port 3000.

```apache
Listen 80
<VirtualHost *:80>
    ServerName your_domain.com
    RailsEnv production
    DocumentRoot /opt/redmine/public

    <Directory "/opt/redmine/public">
        Allow from all
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/redmine_error.log
    CustomLog ${APACHE_LOG_DIR}/redmine_access.log combined
</VirtualHost>
```



<p>Disable the default site configuration.</p>

```
a2dissite 000-default.conf
```

<p>Check Apache configuration for errors.</p>

```
apachectl configtest
```

