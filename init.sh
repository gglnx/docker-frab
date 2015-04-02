#!/bin/sh

# Switch to app dir
cd /home/app/frab

# Symlink system folder
if [ ! -d /home/app/shared/public/ ]; then
	mkdir -p /home/app/shared/public/
	ln -s /home/app/shared/public/ public/system
	chown -R app:app /home/app/shared/public/
fi

# Secrets
if [ ! -f /home/app/frab/config/initializers/secret_token.rb ]; then
	sudo -u app cp config/initializers/secret_token.rb.example config/initializers/secret_token.rb
	sudo -u app sed -i "s/iforgottochangetheexampletokenandnowvisitorscanexecutecodeonmyserver/$(bundle exec rake secret)/g" config/initializers/secret_token.rb
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
