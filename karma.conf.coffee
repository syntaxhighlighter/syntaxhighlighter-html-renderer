module.exports = (config) ->
  config.set
    frameworks: ['browserify', 'mocha', 'chai', 'jquery-2.1.0']
    browsers: if process.env.TRAVIS then ['Firefox'] else ['Chrome']

    preprocessors:
      '**/*.spec.coffee': ['browserify']

    browserify:
      transform: ['coffeeify', 'brfs']
      extensions: ['.coffee']
      noParse: ['cheerio', 'coffee-errors']
      watch: true
      debug: true

    files: [
      'test/**/*.spec.coffee'
    ]
