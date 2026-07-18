## joeycody.com
Personal site built with [Middleman](https://middlemanapp.com).

### Development

Install the Ruby version in `.ruby-version`, then install the Ruby and Node dependencies:

```shell
rbenv install
bundle install
npm ci
npm run build
```

The static site is generated in `/build`.

For local development, run `npm run css:watch` alongside `bundle exec middleman server`.

### Deployment

Deployments use the [`middleman-gh-pages`](https://github.com/edgecase/middleman-gh-pages) extension and publish the generated site to `gh-pages`:

```rb
bundle exec rake build    # Compile static files into build directory
bundle exec rake publish  # Build + publish to `gh-pages` branch
```
