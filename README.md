## joeycody.com
Personal site built with [Middleman](https://middlemanapp.com).

### Development
To create local copy:

```shell
bundle exec middleman build
```
Static site should have been generated in the `/tmp` directory. Preview with `open tmp/index.html`.

### Deployment

Deployments leverage the [`middleman-gh-pages`](https://github.com/edgecase/middleman-gh-pages) extension. To deploy to GH pages:

```rb
bundle exec rake build    # Compile static files into build directory
bundle exec rake publish  # Build + publish to `gh-pages` branch
```

### Renewing SSL-Cert

Currently using a free SSL certificate from [Let's Encrypt](https://letsencrypt.org/). The certificate is valid for 90-days by default, and thus must be renewed to remain valid. The [Certbot](https://certbot.eff.org/) homebrew package makes that easy:

```shell
# Try to renew all certificates in non-interactive mode.
sudo certbot renew

# If that doesn't work, use the interactive mode.
sudo certbot certonly --manual -d joeycody.com
```

##### Feeling Dumb?

- [Publishing to GH Pages via Jekyll (github.com)](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll)
