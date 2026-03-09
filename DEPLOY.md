# Deploy `uts-rsvp.ladderice.co` on a DigitalOcean droplet

This repo is a static site. The droplet only needs Nginx and a TLS certificate.

## 1. Clone or pull the repo on the droplet

Use a stable path that Nginx can serve directly:

```bash
sudo mkdir -p /var/www/uts-rsvp.ladderice.co
sudo chown -R $USER:$USER /var/www/uts-rsvp.ladderice.co
git clone https://github.com/sstrntu/ladderice-uts-registration.git /var/www/uts-rsvp.ladderice.co
```

If the repo is already there:

```bash
cd /var/www/uts-rsvp.ladderice.co
git pull origin main
```

## 2. Install Nginx and Certbot

```bash
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx
```

## 3. Install the Nginx site config

```bash
sudo cp deploy/nginx/uts-rsvp.ladderice.co.conf /etc/nginx/sites-available/uts-rsvp.ladderice.co.conf
sudo ln -sf /etc/nginx/sites-available/uts-rsvp.ladderice.co.conf /etc/nginx/sites-enabled/uts-rsvp.ladderice.co.conf
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

## 4. Issue the TLS certificate

Make sure the DNS A record for `uts-rsvp.ladderice.co` already points at the droplet public IP before this step.

```bash
sudo certbot --nginx -d uts-rsvp.ladderice.co
```

Choose the redirect option when Certbot asks, so HTTP redirects to HTTPS.

## 5. Update the site later

```bash
cd /var/www/uts-rsvp.ladderice.co
git pull origin main
sudo systemctl reload nginx
```

## Notes

- The RSVP form posts to Google Apps Script from the browser, so no backend service is required on the droplet.
- The Nginx config denies access to dotfiles such as `.git`.
