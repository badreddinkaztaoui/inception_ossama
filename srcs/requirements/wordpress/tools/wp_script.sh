# #!/bin/bash
# set -e

# # Wait for MariaDB
# echo "Waiting for MariaDB..."
# until mariadb -h mariadb -u $DB_USER -p$DB_PASSWORD -e ";" 2>/dev/null
# do
#   echo "MariaDB is unavailable - sleeping"
#   sleep 2
# done
# echo "MariaDB is up - executing WordPress setup"

# # Check for required environment variables
# for var in DB_NAME DB_USER DB_PASSWORD DB_HOST DOMAIN_NAME WP_TITLE WP_ADMIN_LOGIN WP_ADMIN_PASSWORD WP_ADMIN_EMAIL WP_AUTHOR_LOGIN WP_AUTHOR_EMAIL WP_AUTHOR_PASSWORD; do
#   if [ -z "${!var}" ]; then
#     echo "Error: Environment variable $var is not set!"
#     exit 1
#   fi
# done

# # Initialize WordPress (if not already configured)
# if [[ ! -f wp-config.php ]]; then
#   echo "Creating WordPress configuration..."
#   wp config create \
#     --dbname="$DB_NAME" \
#     --dbuser="$DB_USER" \
#     --dbpass="$DB_PASSWORD" \
#     --dbhost="$DB_HOST" \
#     --allow-root

#   echo "Installing WordPress..."
#   wp core install \
#     --url="$DOMAIN_NAME" \
#     --title="$WP_TITLE" \
#     --admin_user="$WP_ADMIN_LOGIN" \
#     --admin_password="$WP_ADMIN_PASSWORD" \
#     --admin_email="$WP_ADMIN_EMAIL" \
#     --allow-root

#   echo "Creating subscriber user..."
#   wp user create \
#     "$WP_AUTHOR_LOGIN" \
#     "$WP_AUTHOR_EMAIL" \
#     --role=subscriber \
#     --user_pass="$WP_AUTHOR_PASSWORD" \
#     --allow-root

#   echo "Activating theme..."
#   # wp theme install kubio --activate --allow-root

#   echo "WordPress setup complete!"
# else
#   echo "WordPress is already configured."
# fi

# echo "Starting PHP-FPM..."
# exec php-fpm7.4 -F

#!/bin/bash

# Set ownership of WordPress directory (similar to first script)
chown -R www-data:www-data /var/www/html/

# Move wp-config.php if it doesn't exist (similar to first script)
if [ ! -f "/var/www/html/wp-config.php" ]; then
   mv /wp-config.php /var/www/html/
fi

# Brief delay to ensure environment is ready (similar to first script's sleep 10)
sleep 10

# Download WordPress core if not present (similar to first script)
wp --allow-root --path="/var/www/html/" core download || true

# Install WordPress if not already installed (similar to first script)
if ! wp --allow-root --path="/var/www/html/" core is-installed; then
    wp --allow-root --path="/var/www/html/" core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_LOGIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"
fi

# Create additional user if not exists (similar to first script)
if ! wp --allow-root --path="/var/www/html/" user get "$WP_AUTHOR_LOGIN"; then
    wp --allow-root --path="/var/www/html/" user create \
        "$WP_AUTHOR_LOGIN" \
        "$WP_AUTHOR_EMAIL" \
        --user_pass="$WP_AUTHOR_PASSWORD" \
        --role=subscriber
fi

# Install and activate theme (similar to first script)
wp --path="/var/www/html/" theme install kubio --activate --allow-root

# Start PHP-FPM (retained from original second script)
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
