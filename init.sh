#!/bin/sh

# Switch to app dir
cd /home/app/frab

# Create shared public folder if it doesn't exist
if [ ! -d /home/app/shared/public/ ]; then
	mkdir -p /home/app/shared/public/
	chown -R app:app /home/app/shared/public/
fi

# Symlink system folder
if [ ! -h public/system ]; then
	ln -s /home/app/shared/public/ public/system
fi

# Generate secret token and symlink it into the application
if [ ! -f /home/app/frab/config/initializers/secret_token.rb ]; then
	if [ ! -f /home/app/shared/secret_token.rb ]; then
		SECRET = `sudo -u app RAILS_ENV=production bundle exec rake secret`
		cp config/initializers/secret_token.rb.example /home/app/shared/secret_token.rb
		sed -i "s/iforgottochangetheexampletokenandnowvisitorscanexecutecodeonmyserver/$SECRET/g" /home/app/shared/secret_token.rb
	fi

	ln -s /home/app/shared/secret_token.rb config/initializers/secret_token.rb
fi

# Symlink configuration
if [ ! -f /home/app/frab/config/database.yml ]; then
	ln -s /home/app/shared/database.yml /home/app/frab/config/database.yml
fi

if [ ! -f /home/app/frab/config/settings.yml ]; then
        ln -s /home/app/shared/settings.yml /home/app/frab/config/settings.yml
fi

# Precompile assets
sudo -u app RAILS_ENV=production bundle exec rake assets:precompile

# Setup database if frab is not installed
if [ ! -f /home/app/shared/installed ]; then
	sudo -u app RAILS_ENV=production bundle exec rake db:setup
	touch /home/app/shared/installed
fi

# Migrate database on startup
sudo -u app RAILS_ENV=production bundle exec rake db:migrate
